import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/profile/data/models/contributions_model.dart';

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
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

class _ContributionChartState extends State<ContributionChart> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = _mapContributionsToGrid(widget.contributions, widget.weeks);
    final totalContributions = widget.contributions.fold<int>(0, (sum, c) => sum + c.count);

    return Container(
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
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, int totalContributions) {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Contribution Activity✨',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
                fontSize: 16.sp,
              ),
            ),
          ),
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
    );
  }

  Widget _buildChart(ThemeData theme, List<List<int>> data) {
    final monthLabels = _getMonthLabels(widget.weeks);

    return SizedBox(
      height: (7 * widget.cellSize.w) + (6 * widget.cellSpacing.w) + 20.h,
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
          // Heatmap grid
          Expanded(
            child: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: (widget.weeks * (widget.cellSize.w + widget.cellSpacing.w)) - widget.cellSpacing.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Month labels
                      Row(
                        children: List.generate(widget.weeks, (week) {
                          return Padding(
                            padding: EdgeInsets.only(right: week < widget.weeks - 1 ? widget.cellSpacing.w : 0),
                            child: SizedBox(
                              width: widget.cellSize.w,
                              height: 20.h,
                              child: Text(
                                monthLabels[week] ?? '',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                                  fontSize: 9.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }),
                      ),
                      // Grid
                      SizedBox(
                        height: (7 * widget.cellSize.w) + (6 * widget.cellSpacing.w),
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            mainAxisSpacing: widget.cellSpacing.w,
                            crossAxisSpacing: widget.cellSpacing.w,
                            childAspectRatio: 1.0,
                          ),
                          itemCount: widget.weeks * 7,
                          itemBuilder: (context, index) {
                            final week = index ~/ 7;
                            final day = index % 7;
                            final value = data[week][day];

                            return Container(
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
                            );
                          },
                        ),
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

  List<String?> _getMonthLabels(int weeks) {
    // Get the date range that covers all contributions
    final dates = widget.contributions.map((c) => c.dateOnly).toList();
    if (dates.isEmpty) {
      final now = DateTime.now();
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      List<String?> labels = List.filled(weeks, null);
      for (int week = 0; week < weeks; week++) {
        final weekDate = now.subtract(Duration(days: week * 7));
        if (week == 0 || weekDate.month != now.subtract(Duration(days: (week - 1) * 7)).month) {
          labels[week] = months[weekDate.month - 1];
        }
      }
      return labels;
    }

    dates.sort();
    final startDate = dates.first;
    final endDate = dates.last;

    // Calculate start of the chart (start of week containing startDate)
    final startOfWeek = startDate.subtract(Duration(days: startDate.weekday % 7));

    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    List<String?> labels = List.filled(weeks, null);

    for (int week = 0; week < weeks; week++) {
      final weekDate = startOfWeek.add(Duration(days: week * 7));
      if (week == 0 || weekDate.month != startOfWeek.add(Duration(days: (week - 1) * 7)).month) {
        labels[week] = months[weekDate.month - 1];
      }
    }
    return labels;
  }

  List<List<int>> _mapContributionsToGrid(List<UserContribution> contributions, int weeks) {
    if (contributions.isEmpty) {
      return List.generate(weeks, (_) => List.filled(7, 0));
    }

    // Sort contributions by date
    final sortedContributions = [...contributions];
    sortedContributions.sort((a, b) => a.dateOnly.compareTo(b.dateOnly));

    // Get the date range
    final startDate = sortedContributions.first.dateOnly;
    final endDate = sortedContributions.last.dateOnly;

    // Calculate the start of the chart (start of week containing the earliest date)
    final chartStart = startDate.subtract(Duration(days: startDate.weekday % 7));

    // Initialize grid
    List<List<int>> grid = List.generate(weeks, (_) => List.filled(7, 0));

    // Create a map for faster lookup
    final contributionMap = <String, int>{};
    for (final c in contributions) {
      final dateKey = "${c.dateOnly.year}-${c.dateOnly.month.toString().padLeft(2, '0')}-${c.dateOnly.day.toString().padLeft(2, '0')}";
      contributionMap[dateKey] = c.count;
    }

    // Fill the grid
    for (int week = 0; week < weeks; week++) {
      for (int day = 0; day < 7; day++) {
        final currentDate = chartStart.add(Duration(days: (week * 7) + day));
        final dateKey = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";

        if (contributionMap.containsKey(dateKey)) {
          grid[week][day] = contributionMap[dateKey]!;
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