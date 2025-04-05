import 'dart:ui';
import 'package:flutter/material.dart';

class ResponsiveUtils {
  // Base dimensions for design (based on standard iPhone layout)
  static const double baseWidth = 390;
  static const double baseHeight = 844;

  // Device screen info
  static double screenWidth(BuildContext context) => 
      MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) => 
      MediaQuery.of(context).size.height;

  // Safe area insets
  static EdgeInsets safePadding(BuildContext context) => 
      MediaQuery.of(context).padding;

  // Responsive width and height based on screen size
  static double w(BuildContext context, double size) => 
      size * screenWidth(context) / baseWidth;
  static double h(BuildContext context, double size) => 
      size * screenHeight(context) / baseHeight;

  // Text sizes
  static double fontSize(BuildContext context, double size) {
    final scale = screenWidth(context) / baseWidth;
    final scaledSize = size * scale;
    // Limit min and max font sizes for readability
    return scaledSize.clamp(size * 0.8, size * 1.2);
  }

  // Responsive padding/margin
  static EdgeInsets padding(BuildContext context, 
      {double horizontal = 0, double vertical = 0}) {
    return EdgeInsets.symmetric(
      horizontal: w(context, horizontal),
      vertical: h(context, vertical),
    );
  }

  static EdgeInsets paddingAll(BuildContext context, double value) {
    return EdgeInsets.all(w(context, value));
  }

  // Get device type
  static DeviceType getDeviceType(BuildContext context) {
    final width = screenWidth(context);
    if (width < 600) return DeviceType.mobile;
    if (width < 1000) return DeviceType.tablet;
    return DeviceType.desktop;
  }
  
  // Responsive grid columns based on device type
  static int gridColumns(BuildContext context) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return 2;
      case DeviceType.tablet:
        return 3;
      case DeviceType.desktop:
        return 4;
    }
  }
  
  // Adaptive layout builder
  static Widget adaptiveBuilder({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.mobile:
        return mobile;
    }
  }
}

// Device types for responsive layouts
enum DeviceType { mobile, tablet, desktop }

// Extension methods for easy usage
extension ResponsiveExtension on BuildContext {
  // Screen size
  double get screenWidth => ResponsiveUtils.screenWidth(this);
  double get screenHeight => ResponsiveUtils.screenHeight(this);
  
  // Responsive dimensions
  double w(double size) => ResponsiveUtils.w(this, size);
  double h(double size) => ResponsiveUtils.h(this, size);
  
  // Font sizes
  double fontSize(double size) => ResponsiveUtils.fontSize(this, size);
  
  // Device info
  DeviceType get deviceType => ResponsiveUtils.getDeviceType(this);
  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isDesktop => deviceType == DeviceType.desktop;
  
  // Padding
  EdgeInsets padding({double horizontal = 0, double vertical = 0}) => 
      ResponsiveUtils.padding(this, horizontal: horizontal, vertical: vertical);
  EdgeInsets paddingAll(double value) => 
      ResponsiveUtils.paddingAll(this, value);
} 