import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  
  const ResponsiveWrapper({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1000) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= 600) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double width;
  final double? maxWidth;
  final double? maxHeight;
  final double? minWidth;
  final double? minHeight;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Alignment? alignment;
  final Color? color;
  final Decoration? decoration;
  
  const ResponsiveContainer({
    Key? key,
    required this.child,
    required this.width,
    this.maxWidth,
    this.maxHeight,
    this.minWidth,
    this.minHeight,
    this.padding,
    this.margin,
    this.alignment,
    this.color,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Calculate responsive width as percentage of screen width
    final responsiveWidth = screenWidth * (width / 100);
    
    return Container(
      width: responsiveWidth,
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? double.infinity,
        maxHeight: maxHeight ?? double.infinity,
        minWidth: minWidth ?? 0,
        minHeight: minHeight ?? 0,
      ),
      padding: padding,
      margin: margin,
      alignment: alignment,
      color: color,
      decoration: decoration,
      child: child,
    );
  }
}

class ResponsiveGridView extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final EdgeInsetsGeometry? padding;
  
  const ResponsiveGridView({
    Key? key,
    required this.children,
    this.spacing = 10,
    this.runSpacing = 10,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine number of columns based on screen width
    final columns = ResponsiveUtils.gridColumns(context);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate item width based on container width and column count
        final width = (constraints.maxWidth - (spacing * (columns - 1))) / columns;
        
        return Padding(
          padding: padding ?? EdgeInsets.zero,
          child: Wrap(
            spacing: context.w(spacing),
            runSpacing: context.h(runSpacing),
            children: children.map((child) {
              return SizedBox(
                width: width,
                child: child,
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;
  
  const ResponsiveRow({
    Key? key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.spacing = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.getDeviceType(context);
    
    // On mobile, convert to column if there are multiple children
    if (deviceType == DeviceType.mobile && children.length > 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children.map((child) {
          return Padding(
            padding: EdgeInsets.only(bottom: context.h(spacing)),
            child: child,
          );
        }).toList(),
      );
    }
    
    // For tablet and desktop, use row layout
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;
        
        if (index < children.length - 1) {
          return Padding(
            padding: EdgeInsets.only(right: context.w(spacing)),
            child: child,
          );
        }
        
        return child;
      }).toList(),
    );
  }
} 