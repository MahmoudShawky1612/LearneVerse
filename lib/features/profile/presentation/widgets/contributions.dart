import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/profile/data/models/contributions_model.dart';
import 'dart:math';

// Custom ScrollBehavior to disable overscroll glow
class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child; // Removes the glow effect
  }
}

class ContributionChart extends StatefulWidget {
  final List<UserContribution> contributions;
  final int weeks;
  final double cellSize;
  final double cellSpacing;

  const ContributionChart({
    super.key,
    required this.contributions,
    this.weeks = 52,
    this.cellSize = 12.0,
    this.cellSpacing = 2.0,
  });

  @override
  State<ContributionChart> createState() => _ContributionChartState();
}

class _ContributionChartState extends State<ContributionChart>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;
  late ScrollController _scrollController; // Shared ScrollController

  String? _hoveredDate;
  int? _hoveredValue;
  Offset? _tooltipPosition;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    ));

    _scrollController = ScrollController(); // Initialize ScrollController

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose(); // Dispose ScrollController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = _mapContributionsToGrid(widget.contributions, widget.weeks);
    final totalContributions = widget.contributions.fold<int>(0, (sum, c) => sum + c.count);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeInAnimation,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.surface,
                  theme.colorScheme.surface.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(theme, totalContributions),
                SizedBox(height: 16.h),
                _buildChart(theme, data),
                SizedBox(height: 16.h),
                _buildLegend(theme),
                if (_hoveredDate != null) _buildTooltip(theme),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(ThemeData theme, int totalContributions) {
    final maxStreak = _calculateMaxStreak();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withOpacity(0.08),
            theme.colorScheme.secondary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.15),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Contribution Activity✨',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primary.withOpacity(0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          totalContributions.toString(),
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18.sp,
                          ),
                        ),
                        Text(
                          'contributions',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                            fontSize: 9.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChart(ThemeData theme, List<List<int>> data) {
    final monthLabels = _getMonthLabels(widget.weeks);

    return SizedBox(
      height: (7 * widget.cellSize.w) + (6 * widget.cellSpacing.w) + 20.h, // Height for 7 rows + spacing + month labels
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day labels (Mon, Wed, Fri)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(7, (day) {
              if (day == 1 || day == 3 || day == 5) {
                return Padding(
                  padding: EdgeInsets.only(bottom: day < 6 ? widget.cellSpacing.w : 0),
                  child: SizedBox(
                    width: 30.w,
                    height: widget.cellSize.w,
                    child: Text(
                      ['Mon', 'Wed', 'Fri'][(day - 1) ~/ 2],
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 10.sp,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: EdgeInsets.only(bottom: day < 6 ? widget.cellSpacing.w : 0),
                  child: SizedBox(
                    width: 30.w,
                    height: widget.cellSize.w,
                  ),
                );
              }
            }),
          ),
          SizedBox(width: 8.w),
          // Contribution grid with month labels
          Expanded(
            child: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: (widget.weeks * (widget.cellSize.w + widget.cellSpacing.w)) - widget.cellSpacing.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Month labels
                      Row(
                        children: List.generate(widget.weeks, (week) {
                          final label = monthLabels[week];
                          return Padding(
                            padding: EdgeInsets.only(right: week < widget.weeks - 1 ? widget.cellSpacing.w : 0),
                            child: SizedBox(
                              width: widget.cellSize.w,
                              height: 20.h,
                              child: Text(
                                label ?? '',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                                  fontSize: 10.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }),
                      ),
                      // Contribution grid
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(widget.weeks, (week) {
                          return ScaleTransition(
                            scale: _scaleAnimation,
                            child: Padding(
                              padding: EdgeInsets.only(right: week < widget.weeks - 1 ? widget.cellSpacing.w : 0),
                              child: Column(
                                children: List.generate(7, (day) {
                                  final value = data[week][day];
                                  final date = _getDateForCell(week, day);

                                  return Padding(
                                    padding: EdgeInsets.only(bottom: day < 6 ? widget.cellSpacing.w : 0),
                                    child: MouseRegion(
                                      onEnter: (event) => _showTooltip(date, value, event.position),
                                      onExit: (event) => _hideTooltip(),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        curve: Curves.easeInOut,
                                        width: widget.cellSize.w,
                                        height: widget.cellSize.w,
                                        decoration: BoxDecoration(
                                          color: _getColorForValue(value, theme),
                                          borderRadius: BorderRadius.circular(3.r),
                                          border: value > 0
                                              ? Border.all(
                                            color: theme.colorScheme.primary.withOpacity(0.3),
                                            width: 0.5,
                                          )
                                              : null,
                                          boxShadow: value > 0
                                              ? [
                                            BoxShadow(
                                              color: _getColorForValue(value, theme).withOpacity(0.4),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                              : null,
                                        ),
                                        child: value > 0
                                            ? Center(
                                          child: Container(
                                            width: 2.w,
                                            height: 2.w,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.8),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        )
                                            : null,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Less',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        SizedBox(width: 8.w),
        ...List.generate(5, (index) {
          return Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: _getColorForValue(index, theme),
                borderRadius: BorderRadius.circular(2.r),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                  width: 0.5,
                ),
              ),
            ),
          );
        }),
        SizedBox(width: 8.w),
        Text(
          'More',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildTooltip(ThemeData theme) {
    if (_tooltipPosition == null || _hoveredDate == null) return const SizedBox.shrink();

    return Positioned(
      left: _tooltipPosition!.dx + 30.w, // Adjust for day labels
      top: _tooltipPosition!.dy - 60,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(8.r),
        color: theme.colorScheme.inverseSurface,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _hoveredDate!,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onInverseSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${_hoveredValue} contributions',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onInverseSurface.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTooltip(String date, int value, Offset position) {
    setState(() {
      _hoveredDate = date;
      _hoveredValue = value;
      _tooltipPosition = position;
    });
  }

  void _hideTooltip() {
    setState(() {
      _hoveredDate = null;
      _hoveredValue = null;
      _tooltipPosition = null;
    });
  }

  String _getDateForCell(int week, int day) {
    final now = DateTime.now();
    // Calculate date by going backward from the current date
    final cellDate = now.subtract(Duration(days: (week * 7) + (6 - day)));

    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    return '${months[cellDate.month - 1]} ${cellDate.day}, ${cellDate.year}';
  }

  List<String?> _getMonthLabels(int weeks) {
    final now = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    List<String?> labels = List.filled(weeks, null);

    for (int week = 0; week < weeks; week++) {
      final weekDate = now.subtract(Duration(days: week * 7));
      // Show month label if it's the first week or the month changes
      if (week == 0 || weekDate.month != now.subtract(Duration(days: (week - 1) * 7)).month) {
        labels[week] = months[weekDate.month - 1];
      }
    }
    return labels;
  }

  int _calculateMaxStreak() {
    int maxStreak = 0;
    int currentStreak = 0;

    final sortedContributions = List<UserContribution>.from(widget.contributions)
      ..sort((a, b) => a.dateOnly.compareTo(b.dateOnly));

    DateTime? lastDate;
    for (final contribution in sortedContributions) {
      if (lastDate == null || contribution.dateOnly.difference(lastDate).inDays == 1) {
        currentStreak++;
        maxStreak = max(maxStreak, currentStreak);
      } else {
        currentStreak = 1;
      }
      lastDate = contribution.dateOnly;
    }

    return maxStreak;
  }

  List<List<int>> _mapContributionsToGrid(List<UserContribution> contributions, int weeks) {
    final now = DateTime.now();
    final end = now.subtract(Duration(days: weeks * 7));
    List<List<int>> grid = List.generate(weeks, (_) => List.filled(7, 0));

    for (final c in contributions) {
      // Calculate days from the contribution date to the end date
      final diff = now.difference(c.dateOnly).inDays;
      if (diff >= 0 && diff < weeks * 7) {
        final week = diff ~/ 7;
        final day = (c.dateOnly.weekday + 6) % 7; // Adjust for Sunday=0 to Saturday=6
        if (week < weeks && day < 7) {
          grid[week][day] = c.count;
        }
      }
    }
    return grid;
  }

  Color _getColorForValue(int value, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;

    if (isDark) {
      switch (value) {
        case 0:
          return theme.colorScheme.outline.withOpacity(0.1);
        case 1:
          return primary.withOpacity(0.3);
        case 2:
          return primary.withOpacity(0.5);
        case 3:
          return primary.withOpacity(0.8);
        default:
          return primary;
      }
    } else {
      switch (value) {
        case 0:
          return theme.colorScheme.outline.withOpacity(0.08);
        case 1:
          return primary.withOpacity(0.2);
        case 2:
          return primary.withOpacity(0.4);
        case 3:
          return primary.withOpacity(0.7);
        default:
          return primary;
      }
    }
  }
}