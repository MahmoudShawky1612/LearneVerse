import 'package:flutter/material.dart';
import 'package:flutterwidgets/features/calender/presentation/views/calendar_screen.dart';
import 'package:flutterwidgets/features/discover/presentation/views/discover_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BottomNavigationBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  selectedItemColor: Colors.pink,
                  unselectedItemColor: Colors.black,
                  selectedFontSize: 12,
                  unselectedFontSize: 12,
                  items: [
                    _buildNavItem(
                        FontAwesomeIcons.house, Icons.home_outlined, "Home"),
                    _buildNavItem(FontAwesomeIcons.compass,
                        FontAwesomeIcons.compass, "Discover"),
                    _buildNavItem(FontAwesomeIcons.calendarDays,
                        FontAwesomeIcons.calendar, "Calendar"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData selectedIcon, IconData unselectedIcon, String label) {
    return BottomNavigationBarItem(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Icon(
          _currentIndex == items.indexOf(label) ? selectedIcon : unselectedIcon,
          key: ValueKey<bool>(_currentIndex == items.indexOf(label)),
          size: _currentIndex == items.indexOf(label) ? 28 : 24,
        ),
      ),
      label: _currentIndex == items.indexOf(label) ? label : '',
    );
  }

  List<String> get items => ["Home", "Discover", "Calendar"];
}
