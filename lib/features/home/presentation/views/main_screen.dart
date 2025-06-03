import 'package:flutter/material.dart';
import 'package:flutterwidgets/features/discover/presentation/views/discover_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../calendar/presentation/views/calendar_screen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    const DiscoverScreen(),
    const CalendarScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;

    final horizontalMargin = screenWidth < 360 ? 10.w :
                            screenWidth < 600 ? 30.w : 50.w;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _screens[_currentIndex],
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: 15.h,
                horizontal: horizontalMargin
              ),
              height: 60.h, // Reduced height for a more compact navbar
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.1),
                    blurRadius: 20.r,
                    spreadRadius: 1.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: _buildNavItem(
                        index: 0,
                        icon: FontAwesomeIcons.house,
                        label: "Home",
                      ),
                    ),
                    Expanded(
                      child: _buildNavItem(
                        index: 1,
                        icon: FontAwesomeIcons.compass,
                        label: "Discover",
                      ),
                    ),
                    Expanded(
                      child: _buildNavItem(
                        index: 2,
                        icon: FontAwesomeIcons.calendarDays,
                        label: "Calendar",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.secondary.withOpacity(0.15) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? colorScheme.secondary : colorScheme.onSurface.withOpacity(0.7),
                size: isSelected ? 18.r : 16.r,
              ),
            ),
            if (isSelected)
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: colorScheme.secondary,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

