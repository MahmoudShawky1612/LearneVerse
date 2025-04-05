import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime today = DateTime.now();
  DateTime focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  List<Map<String, dynamic>> events = [
    {'day': DateTime.now(), 'event': 'C++ Quiz', 'color': Colors.deepPurple},
    {
      'day': DateTime(2025, 4, 8),
      'event': 'Flutter Workshop',
      'color': Colors.pink
    },
    {
      'day': DateTime(2025, 4, 15),
      'event': 'Dart Basics',
      'color': Colors.green
    },
    {
      'day': DateTime(2025, 4, 20),
      'event': 'Data Structures',
      'color': Colors.orange
    },
  ];

  List<Map<String, dynamic>> selectedEvents = [];

  void _selectedDay(DateTime day, DateTime newFocusedDay) {
    setState(() {
      today = day;
      focusedDay = newFocusedDay;
      selectedEvents = _getEventsForDay(day);
    });
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return events.where((map) => isSameDay(map['day'], day)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();
    
    return Container(
      child: Scaffold(
        body: Container(
          color: theme.scaffoldBackgroundColor,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Calendar',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onBackground,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (_calendarFormat == CalendarFormat.month) {
                                _calendarFormat = CalendarFormat.week;
                              } else {
                                _calendarFormat = CalendarFormat.month;
                              }
                            });
                          },
                          icon: Icon(
                            _calendarFormat == CalendarFormat.month
                                ? Icons.view_week_rounded
                                : Icons.calendar_view_month_rounded,
                            color: colorScheme.onBackground,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 8,
                      shadowColor: colorScheme.primary.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: theme.cardColor,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TableCalendar(
                          focusedDay: focusedDay,
                          firstDay: DateTime(2025, 1, 1),
                          lastDay: DateTime(2050, 12, 31),
                          calendarFormat: _calendarFormat,
                          rowHeight: 50,
                          daysOfWeekHeight: 30,
                          headerStyle: HeaderStyle(
                            titleCentered: true,
                            formatButtonVisible: false,
                            titleTextStyle: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                            leftChevronIcon: Icon(
                              Icons.chevron_left_rounded,
                              color: colorScheme.onSurface,
                              size: 28,
                            ),
                            rightChevronIcon: Icon(
                              Icons.chevron_right_rounded,
                              color: colorScheme.onSurface,
                              size: 28,
                            ),
                          ),
                          daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: GoogleFonts.poppins(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                            weekendStyle: GoogleFonts.poppins(
                              color: colorScheme.onSurface.withOpacity(0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          calendarStyle: CalendarStyle(
                            defaultTextStyle: GoogleFonts.poppins(
                              color: colorScheme.onSurface,
                            ),
                            weekendTextStyle: GoogleFonts.poppins(
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                            todayDecoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            outsideTextStyle: GoogleFonts.poppins(
                              color: colorScheme.onSurface.withOpacity(0.4),
                            ),
                          ),
                          onDaySelected: _selectedDay,
                          selectedDayPredicate: (day) => isSameDay(today, day),
                          eventLoader: _getEventsForDay,
                          calendarBuilders: CalendarBuilders(
                            markerBuilder: (context, day, events) {
                              if (events.isNotEmpty) {
                                return Positioned(
                                  bottom: 2,
                                  right: 47,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: (events.first as Map)['color'] ??
                                          colorScheme.primary,
                                    ),
                                  ),
                                );
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      selectedEvents.isEmpty
                          ? 'No events on ${today.day}/${today.month}/${today.year}'
                          : 'Events on ${today.day}/${today.month}/${today.year}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: selectedEvents.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: selectedEvents.length,
                              itemBuilder: (context, index) {
                                final event = selectedEvents[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  elevation: 4,
                                  shadowColor: colorScheme.primary.withOpacity(0.3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  color: theme.cardColor,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    leading: Container(
                                      width: 12,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        color: event['color'] ?? colorScheme.primary,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    title: Text(
                                      event['event'],
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.arrow_forward_ios,
                                          size: 16,
                                          color: colorScheme.onSurface),
                                      onPressed: () {
                                        // Event details navigation
                                      },
                                    ),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.event_busy,
                                    size: 60,
                                    color: colorScheme.onSurface.withOpacity(0.5),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "No events scheduled",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: colorScheme.onSurface.withOpacity(0.5),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
