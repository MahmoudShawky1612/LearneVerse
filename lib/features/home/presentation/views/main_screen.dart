import 'package:flutter/material.dart';
import 'package:flutterwidgets/features/discover/presentation/views/discover_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/constants/app_colors.dart';
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
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              height: 75,
              decoration: BoxDecoration(
              color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 25,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(
                      index: 0,
                      icon: FontAwesomeIcons.house,
                      label: "Home",
                    ),
                    _buildNavItem(
                      index: 1,
                      icon: FontAwesomeIcons.compass,
                      label: "Discover",
                    ),
                    _buildNavItem(
                      index: 2,
                      icon: FontAwesomeIcons.calendarDays,
                      label: "Calendar",
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

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        width: 90,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.secondary.withOpacity(0.15) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.secondary : AppColors.textSecondary,
                size: isSelected ? 26 : 22,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isSelected ? label : "",
              style: const TextStyle(
                color: AppColors.secondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}