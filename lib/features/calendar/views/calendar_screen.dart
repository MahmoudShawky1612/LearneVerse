import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../service/reminders_service.dart';
import '../data/models/reminder_model.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime today = DateTime.now();
  DateTime focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final RemindersApiService _remindersService = RemindersApiService();
  List<Map<String, dynamic>> events = [];
  List<Map<String, dynamic>> selectedEvents = [];

  @override
  void initState() {
    super.initState();
    _fetchReminders();
  }

  Future<void> _fetchReminders() async {
    try {
      final reminders = await _remindersService.fetchReminders();
      setState(() {
        events = _processReminders(reminders);
      });
    } catch (e) {
       print('Error fetching reminders: $e');
    }
  }

  List<Map<String, dynamic>> _processReminders(List<Reminder> reminders) {
    List<Map<String, dynamic>> processedEvents = [];
    
    for (var reminder in reminders) {
      for (var classroom in reminder.community.classrooms) {
        for (var quiz in classroom.quizzes) {
          processedEvents.add({
            'day': quiz.startDate,
            'event': '${quiz.name} - ${reminder.community.name}',
            'color': Colors.deepPurple,
          });
        }
      }
    }
    
    return processedEvents;
  }

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
              padding: EdgeInsets.all(16.h),
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
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
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
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Card(
                      elevation: 8,
                      shadowColor: colorScheme.primary.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: theme.cardColor,
                      child: Padding(
                        padding: EdgeInsets.all(12.0.w),
                        child: TableCalendar(
                          focusedDay: focusedDay,
                          firstDay: DateTime(2025, 1, 1),
                          lastDay: DateTime(2050, 12, 31),
                          calendarFormat: _calendarFormat,
                          rowHeight: 50.h,
                          daysOfWeekHeight: 30.h,
                          headerStyle: HeaderStyle(
                            titleCentered: true,
                            formatButtonVisible: false,
                            titleTextStyle: GoogleFonts.poppins(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                            leftChevronIcon: Icon(
                              Icons.chevron_left_rounded,
                              color: colorScheme.onSurface,
                              size: 28.w,
                            ),
                            rightChevronIcon: Icon(
                              Icons.chevron_right_rounded,
                              color: colorScheme.onSurface,
                              size: 28.w,
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
                                  bottom: 9.w,
                                  right: 17.w,
                                  child: Container(
                                    width: 8.w,
                                    height: 8.h,
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
                    SizedBox(height: 24.h),
                    Text(
                      selectedEvents.isEmpty
                          ? 'No events on ${today.day}/${today.month}/${today.year}'
                          : 'Events on ${today.day}/${today.month}/${today.year}',
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      constraints: BoxConstraints(maxHeight: 200.h),
                      child: selectedEvents.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: selectedEvents.length,
                              itemBuilder: (context, index) {
                                final event = selectedEvents[index];
                                return Card(
                                  margin: EdgeInsets.only(bottom: 12.h),
                                  elevation: 4,
                                  shadowColor:
                                      colorScheme.primary.withOpacity(0.3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  color: theme.cardColor,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    leading: Container(
                                      width: 12.w,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        color: event['color'] ??
                                            colorScheme.primary,
                                        borderRadius:
                                            BorderRadius.circular(30.r),
                                      ),
                                    ),
                                    title: Text(
                                      event['event'],
                                      style: GoogleFonts.poppins(
                                        fontSize: 16.w,
                                        fontWeight: FontWeight.w600,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.arrow_forward_ios,
                                          size: 16.w,
                                          color: colorScheme.onSurface),
                                      onPressed: () {

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
                                    size: 60.w,
                                    color:
                                        colorScheme.onSurface.withOpacity(0.5),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    "No events scheduled",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: colorScheme.onSurface
                                          .withOpacity(0.5),
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
