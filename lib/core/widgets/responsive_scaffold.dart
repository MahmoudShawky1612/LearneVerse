import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

class ResponsiveScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;
  final double mobileHorizontalPadding;
  final double tabletHorizontalPadding;
  final double desktopHorizontalPadding;
  final double maxWidth;
  final bool centerContent;
  final bool extendBody;

  const ResponsiveScaffold({
    Key? key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.mobileHorizontalPadding = 16.0,
    this.tabletHorizontalPadding = 24.0,
    this.desktopHorizontalPadding = 32.0,
    this.maxWidth = 1200.0,
    this.centerContent = true,
    this.extendBody = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      extendBody: extendBody,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final deviceType = ResponsiveUtils.getDeviceType(context);
          
          // Determine the horizontal padding based on device type
          final horizontalPadding = deviceType == DeviceType.mobile
              ? context.w(mobileHorizontalPadding)
              : deviceType == DeviceType.tablet
                  ? context.w(tabletHorizontalPadding)
                  : context.w(desktopHorizontalPadding);
          
          Widget contentWidget = Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: body,
          );
          
          // For tablet and desktop, center the content and limit max width
          if (deviceType != DeviceType.mobile && centerContent) {
            contentWidget = Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: contentWidget,
              ),
            );
          }
          
          return contentWidget;
        },
      ),
    );
  }
}

// Extension to create specialized scaffold variants
extension ResponsiveScaffoldExtension on ResponsiveScaffold {
  // For screens with a floating action button in the center
  static Widget withCenteredFAB({
    required BuildContext context,
    required Widget body,
    PreferredSizeWidget? appBar,
    required Widget floatingActionButton,
    Widget? bottomNavigationBar,
    Color? backgroundColor,
  }) {
    return ResponsiveScaffold(
      body: body,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: bottomNavigationBar,
      backgroundColor: backgroundColor,
      extendBody: true,
    );
  }
  
  // For screens with a bottom navigation bar
  static Widget withBottomNavBar({
    required BuildContext context,
    required Widget body,
    PreferredSizeWidget? appBar,
    required Widget bottomNavigationBar,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    Color? backgroundColor,
  }) {
    return ResponsiveScaffold(
      body: body,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      backgroundColor: backgroundColor,
      extendBody: true,
    );
  }
  
  // For screens with a side drawer - adapts to tablet/desktop layouts
  static Widget withAdaptiveDrawer({
    required BuildContext context,
    required Widget body,
    PreferredSizeWidget? appBar,
    required Widget drawerContent,
    Widget? bottomNavigationBar,
    Color? backgroundColor,
  }) {
    final deviceType = ResponsiveUtils.getDeviceType(context);
    
    // On tablets and desktops, show drawer permanently on the side
    if (deviceType != DeviceType.mobile) {
      return Scaffold(
        appBar: appBar,
        backgroundColor: backgroundColor,
        bottomNavigationBar: bottomNavigationBar,
        body: Row(
          children: [
            SizedBox(
              width: deviceType == DeviceType.tablet 
                  ? 250 
                  : 300,
              child: Drawer(
                elevation: 0,
                child: drawerContent,
              ),
            ),
            Expanded(
              child: ResponsiveScaffold(
                body: body,
                backgroundColor: backgroundColor,
                centerContent: true,
              ),
            ),
          ],
        ),
      );
    }
    
    // On mobile, use a standard drawer
    return ResponsiveScaffold(
      body: body,
      appBar: appBar,
      drawer: Drawer(child: drawerContent),
      bottomNavigationBar: bottomNavigationBar,
      backgroundColor: backgroundColor,
    );
  }
} 