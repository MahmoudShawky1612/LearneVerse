import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A modern, customizable contribution chart widget with enhanced visual appeal
class ContributionChart extends StatelessWidget {
  /// Creates a contribution chart
  const ContributionChart({
    super.key,
    this.data,
    this.weeks = 52,
    this.cellSize = 12.0,
    this.cellSpacing = 2.0,
    this.cornerRadius = 2.0,
    this.showMonthLabels = true,
    this.showDayLabels = true,
    this.colorScheme,
    this.onCellTap,
    this.tooltipBuilder,
    this.animationDuration = const Duration(milliseconds: 300),
    this.showGradientOverlay = true,
    this.enablePulseAnimation = false,
  });

  /// Contribution data as a 2D list [week][day]
  /// If null, generates random data for demonstration
  final List<List<int>>? data;

  /// Number of weeks to display (default: 52 for a full year)
  final int weeks;

  /// Size of each contribution cell
  final double cellSize;

  /// Spacing between cells
  final double cellSpacing;

  /// Corner radius for cells
  final double cornerRadius;

  /// Whether to show month labels
  final bool showMonthLabels;

  /// Whether to show day labels (S, M, T, W, T, F, S)
  final bool showDayLabels;

  /// Custom color scheme for the chart
  final ContributionColorScheme? colorScheme;

  /// Callback when a cell is tapped
  final void Function(int week, int day, int value)? onCellTap;

  /// Custom tooltip builder
  final Widget Function(int week, int day, int value)? tooltipBuilder;

  /// Animation duration for cell hover effects
  final Duration animationDuration;

  /// Whether to show gradient overlay effect
  final bool showGradientOverlay;

  /// Whether to enable pulse animation for high-value cells
  final bool enablePulseAnimation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = colorScheme ?? ContributionColorScheme.fromTheme(theme);
    final contributionData = data ?? _generateSampleData();

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final cellWidth = cellSize.w;
        final spacing = cellSpacing.w;
        final dayLabelWidth = showDayLabels ? 30.w : 0;
        final totalCellWidth = (cellWidth + spacing) * weeks - spacing;
        final totalWidth = totalCellWidth + dayLabelWidth;

        return Container(
          decoration: showGradientOverlay
              ? BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.5,
              colors: [
                colors.level1.withOpacity(0.05),
                Colors.transparent,
              ],
            ),
          )
              : null,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Container(
              width: max(totalWidth, availableWidth),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showMonthLabels) _buildMonthLabels(colors, theme),
                  if (showMonthLabels) SizedBox(height: (cellSpacing * 2).h),
                  _buildChart(contributionData, colors, context),
                  SizedBox(height: (cellSpacing * 2).h),
                  _buildEnhancedLegend(colors, theme),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMonthLabels(ContributionColorScheme colors, ThemeData theme) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    return Padding(
      padding: EdgeInsets.only(left: showDayLabels ? 30.w : 0),
      child: SizedBox(
        height: 20.h,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(weeks, (weekIndex) {
              final monthIndex = (weekIndex * 12 / weeks).floor();
              final showLabel = weekIndex % (weeks / 12).ceil() == 0;

              return SizedBox(
                width: (cellSize + cellSpacing).w,
                child: showLabel && monthIndex < months.length
                    ? AnimatedOpacity(
                  opacity: 1.0,
                  duration: Duration(milliseconds: 200 + weekIndex * 20),
                  child: Text(
                    months[monthIndex],
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.textColor,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                )
                    : null,
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildChart(List<List<int>> contributionData, ContributionColorScheme colors, BuildContext context) {
    final dayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showDayLabels) _buildDayLabels(dayLabels, colors, context),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              height: (7 * (cellSize.w + cellSpacing.w) - cellSpacing.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: List.generate(weeks, (weekIndex) {
                  return Padding(
                    padding: EdgeInsets.only(right: weekIndex < weeks - 1 ? cellSpacing.w : 0),
                    child: Column(
                      children: List.generate(7, (dayIndex) {
                        final value = weekIndex < contributionData.length &&
                            dayIndex < contributionData[weekIndex].length
                            ? contributionData[weekIndex][dayIndex]
                            : 0;

                        return Padding(
                          padding: EdgeInsets.only(bottom: dayIndex < 6 ? cellSpacing.w : 0),
                          child: TweenAnimationBuilder<double>(
                            duration: Duration(milliseconds: 500 + (weekIndex * 10)),
                            tween: Tween(begin: 0.0, end: 1.0),
                            curve: Curves.elasticOut,
                            builder: (context, animation, child) {
                              return Transform.scale(
                                scale: animation,
                                child: _ContributionCell(
                                  value: value,
                                  size: cellSize.w,
                                  cornerRadius: cornerRadius.r,
                                  color: colors.getColorForValue(value),
                                  animationDuration: animationDuration,
                                  enablePulseAnimation: enablePulseAnimation && value >= 3,
                                  onTap: onCellTap != null
                                      ? () => onCellTap!(weekIndex, dayIndex, value)
                                      : null,
                                  tooltip: tooltipBuilder?.call(weekIndex, dayIndex, value),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayLabels(List<String> dayLabels, ContributionColorScheme colors, BuildContext context) {
    return Container(
      width: 25.w,
      margin: EdgeInsets.only(right: 5.w),
      child: Column(
        children: List.generate(7, (index) {
          return Container(
            height: cellSize.w + (index < 6 ? cellSpacing.w : 0),
            alignment: Alignment.centerRight,
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 300 + index * 100),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: colors.level0.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(3.r),
                ),
                child: Text(
                  dayLabels[index],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.textColor,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEnhancedLegend(ContributionColorScheme colors, ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colors.level0.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: colors.level1.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Less',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.textColor,
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 12.w),
          Row(
            children: List.generate(5, (index) {
              return Padding(
                padding: EdgeInsets.only(right: index < 4 ? 3.w : 0),
                child: TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 800 + index * 100),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.bounceOut,
                  builder: (context, animation, child) {
                    return Transform.scale(
                      scale: animation,
                      child: Container(
                        width: (cellSize * 0.8).w,
                        height: (cellSize * 0.8).w,
                        decoration: BoxDecoration(
                          color: colors.getColorForValue(index),
                          borderRadius: BorderRadius.circular((cornerRadius * 0.8).r),
                          boxShadow: [
                            BoxShadow(
                              color: colors.getColorForValue(index).withOpacity(0.4),
                              blurRadius: 3.r,
                              spreadRadius: 0.5.r,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
          SizedBox(width: 12.w),
          Text(
            'More',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.textColor,
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  List<List<int>> _generateSampleData() {
    final random = Random(42);
    return List.generate(
      weeks,
          (_) => List.generate(7, (_) => random.nextInt(5)),
    );
  }
}

/// Individual contribution cell widget with enhanced effects
class _ContributionCell extends StatefulWidget {
  const _ContributionCell({
    required this.value,
    required this.size,
    required this.cornerRadius,
    required this.color,
    required this.animationDuration,
    this.onTap,
    this.tooltip,
    this.enablePulseAnimation = false,
  });

  final int value;
  final double size;
  final double cornerRadius;
  final Color color;
  final Duration animationDuration;
  final VoidCallback? onTap;
  final Widget? tooltip;
  final bool enablePulseAnimation;

  @override
  State<_ContributionCell> createState() => _ContributionCellState();
}

class _ContributionCellState extends State<_ContributionCell>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.enablePulseAnimation) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget cell = AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _pulseAnimation]),
      builder: (context, child) {
        final scale = _scaleAnimation.value *
            (widget.enablePulseAnimation ? _pulseAnimation.value : 1.0);

        return Transform.scale(
          scale: scale,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              gradient: _isHovered
                  ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  widget.color,
                  widget.color.withOpacity(0.7),
                ],
              )
                  : null,
              color: _isHovered ? null : widget.color,
              borderRadius: BorderRadius.circular(widget.cornerRadius),
              boxShadow: _isHovered
                  ? [
                BoxShadow(
                  color: widget.color.withOpacity(0.6),
                  blurRadius: 8.r,
                  spreadRadius: 2.r,
                  offset: Offset(0, 2.h),
                ),
                BoxShadow(
                  color: widget.color.withOpacity(0.3),
                  blurRadius: 16.r,
                  spreadRadius: 4.r,
                  offset: Offset(0, 4.h),
                ),
              ]
                  : widget.value > 0
                  ? [
                BoxShadow(
                  color: widget.color.withOpacity(0.3),
                  blurRadius: 2.r,
                  spreadRadius: 0.5.r,
                  offset: Offset(0, 1.h),
                ),
              ]
                  : null,
            ),
            child: _isHovered && widget.value > 0
                ? Center(
              child: Icon(
                Icons.stars_rounded,
                size: (widget.size * 0.6),
                color: Colors.white.withOpacity(0.8),
              ),
            )
                : null,
          ),
        );
      },
    );

    if (widget.tooltip != null) {
      cell = Tooltip(
        message: '',
        child: cell,
      );
    }

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _scaleController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _scaleController.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: cell,
      ),
    );
  }
}

/// Enhanced color scheme for the contribution chart
class ContributionColorScheme {
  const ContributionColorScheme({
    required this.level0,
    required this.level1,
    required this.level2,
    required this.level3,
    required this.level4,
    required this.textColor,
  });

  final Color level0;
  final Color level1;
  final Color level2;
  final Color level3;
  final Color level4;
  final Color textColor;

  /// Creates a vibrant color scheme based on the current theme
  factory ContributionColorScheme.fromTheme(ThemeData theme) {
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return ContributionColorScheme(
      level0: primary.withOpacity(0.08),
      level1: primary.withOpacity(0.25),
      level2: primary.withOpacity(0.5),
      level3: primary.withOpacity(0.75),
      level4: primary,
      textColor: onSurface.withOpacity(0.7),
    );
  }

  /// Creates a modern neon color scheme
  factory ContributionColorScheme.neon() {
    return const ContributionColorScheme(
      level0: Color(0xFF1A1A2E),
      level1: Color(0xFF16213E),
      level2: Color(0xFF0F3460),
      level3: Color(0xFF533483),
      level4: Color(0xFFE94560),
      textColor: Color(0xFFE5E5E5),
    );
  }

  /// Creates a GitHub-style enhanced green color scheme
  factory ContributionColorScheme.github() {
    return const ContributionColorScheme(
      level0: Color(0xFFEBEDF0),
      level1: Color(0xFF9BE9A8),
      level2: Color(0xFF40C463),
      level3: Color(0xFF30A14E),
      level4: Color(0xFF216E39),
      textColor: Color(0xFF586069),
    );
  }

  /// Creates a sunset gradient color scheme
  factory ContributionColorScheme.sunset() {
    return const ContributionColorScheme(
      level0: Color(0xFFFFF8E1),
      level1: Color(0xFFFFE082),
      level2: Color(0xFFFFB74D),
      level3: Color(0xFFFF8A65),
      level4: Color(0xFFFF5722),
      textColor: Color(0xFF5D4037),
    );
  }

  /// Gets the appropriate color for a contribution value
  Color getColorForValue(int value) {
    switch (value) {
      case 0:
        return level0;
      case 1:
        return level1;
      case 2:
        return level2;
      case 3:
        return level3;
      case 4:
      default:
        return level4;
    }
  }
}

/// Enhanced header widget with contribution chart and statistics
class ContributionHeader extends StatelessWidget {
  const ContributionHeader({
    super.key,
    this.totalContributions = 364,
    this.data,
    this.colorScheme,
    this.onCellTap,
    this.showStats = true,
    this.animateOnLoad = true,
  });

  final int totalContributions;
  final List<List<int>>? data;
  final ContributionColorScheme? colorScheme;
  final void Function(int week, int day, int value)? onCellTap;
  final bool showStats;
  final bool animateOnLoad;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final contributionData = data ?? _generateSampleData();
    final stats = _calculateStats(contributionData);

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: animateOnLoad ? 0.0 : 1.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, animation, child) {
        return Transform.scale(
          scale: animation,
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 20.h),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.cardColor,
                  theme.cardColor.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.1),
                  blurRadius: 20.r,
                  spreadRadius: 5.r,
                  offset: Offset(0, 8.h),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  blurRadius: 1.r,
                  spreadRadius: 0,
                  offset: Offset(0, -1.h),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary,
                            colorScheme.primary.withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.timeline_rounded,
                        color: Colors.white,
                        size: 24.w,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Yearly Contributions",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            "$totalContributions contributions in the last year",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: colorScheme.onSurface.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                if (showStats) ...[
                  SizedBox(height: 16.h),
                  _buildStatsRow(stats, colorScheme),
                ],

                SizedBox(height: 20.h),
                Container(
                  height: 140.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: colorScheme.outline.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: ContributionChart(
                    data: contributionData,
                    colorScheme: this.colorScheme,
                    cellSize: 11.0,
                    cellSpacing: 2.5,
                    cornerRadius: 3.0,
                    showMonthLabels: true,
                    showDayLabels: false,
                    showGradientOverlay: true,
                    enablePulseAnimation: true,
                    onCellTap: onCellTap,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsRow(Map<String, dynamic> stats, ColorScheme colorScheme) {
    return Row(
      children: [
        _buildStatItem("Streak", "${stats['maxStreak']}", Icons.local_fire_department_rounded, colorScheme),
        SizedBox(width: 16.w),
        _buildStatItem("Best Day", "${stats['maxDay']}", Icons.star_rounded, colorScheme),
        SizedBox(width: 16.w),
        _buildStatItem("Average", "${stats['average']}", Icons.trending_up_rounded, colorScheme),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, ColorScheme colorScheme) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: colorScheme.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16.w, color: colorScheme.primary),
            SizedBox(width: 6.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<List<int>> _generateSampleData() {
    final random = Random(42);
    return List.generate(52, (week) {
      return List.generate(7, (day) {
        if (day == 0 || day == 6) {
          return random.nextBool() ? 0 : random.nextInt(3);
        } else {
          final baseActivity = random.nextInt(5);
          if (week % 10 == 0 && random.nextBool()) {
            return 0;
          }
          return baseActivity;
        }
      });
    });
  }

  Map<String, dynamic> _calculateStats(List<List<int>> data) {
    int total = 0;
    int maxDay = 0;
    int currentStreak = 0;
    int maxStreak = 0;

    for (final week in data) {
      for (final day in week) {
        total += day;
        if (day > maxDay) maxDay = day;

        if (day > 0) {
          currentStreak++;
          if (currentStreak > maxStreak) maxStreak = currentStreak;
        } else {
          currentStreak = 0;
        }
      }
    }

    final totalDays = data.length * 7;
    final average = totalDays > 0 ? (total / totalDays).toStringAsFixed(1) : "0.0";

    return {
      'total': total,
      'maxDay': maxDay,
      'maxStreak': maxStreak,
      'average': average,
    };
  }
}

/// Example usage widget with multiple creative themes
class ContributionChartExample extends StatefulWidget {
  const ContributionChartExample({super.key});

  @override
  State<ContributionChartExample> createState() => _ContributionChartExampleState();
}

class _ContributionChartExampleState extends State<ContributionChartExample> {
  int selectedTheme = 0;
  final themes = [
    {'name': 'Default', 'scheme': null},
    {'name': 'GitHub', 'scheme': ContributionColorScheme.github()},
    {'name': 'Neon', 'scheme': ContributionColorScheme.neon()},
    {'name': 'Sunset', 'scheme': ContributionColorScheme.sunset()},
  ];

  @override
  Widget build(BuildContext context) {
    final sampleData = _generateRealisticData();
    final totalContributions = _calculateTotal(sampleData);
    final currentScheme = themes[selectedTheme]['scheme'] as ContributionColorScheme?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enhanced Contribution Chart'),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withOpacity(0.8),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Theme selector
            Container(
              margin: EdgeInsets.only(bottom: 16.h),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(themes.length, (index) {
                    final isSelected = selectedTheme == index;
                    return GestureDetector(
                      onTap: () => setState(() => selectedTheme = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: EdgeInsets.only(right: 8.w),
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: isSelected
                              ? [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                              blurRadius: 8.r,
                              spreadRadius: 2.r,
                            ),
                          ]
                              : null,
                        ),
                        child: Text(
                          themes[index]['name'] as String,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurface,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            // Enhanced header with chart
            ContributionHeader(
              totalContributions: totalContributions,
              data: sampleData,
              colorScheme: currentScheme,
              showStats: true,
              animateOnLoad: true,
              onCellTap: (week, day, value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.white, size: 20.w),
                        SizedBox(width: 8.w),
                        Text('Week $week, Day $day: $value contributions'),
                      ],
                    ),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 24.h),

            // Standalone enhanced chart
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).cardColor,
                    Theme.of(context).cardColor.withOpacity(0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.1),
                    blurRadius: 20.r,
                    spreadRadius: 5.r,
                    offset: Offset(0, 8.h),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: currentScheme != null
                                  ? [currentScheme.level4, currentScheme.level3]
                                  : [
                                Theme.of(context).colorScheme.secondary,
                                Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.auto_graph_rounded,
                            color: Colors.white,
                            size: 24.w,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${themes[selectedTheme]['name']} Style Chart',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                'Interactive contribution visualization',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: ContributionChart(
                        data: sampleData,
                        cellSize: 14,
                        cellSpacing: 3,
                        cornerRadius: 4,
                        colorScheme: currentScheme,
                        showGradientOverlay: true,
                        enablePulseAnimation: selectedTheme == 2, // Enable for neon theme
                        onCellTap: (week, day, value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(Icons.touch_app_rounded, color: Colors.white, size: 20.w),
                                  SizedBox(width: 8.w),
                                  Text('${themes[selectedTheme]['name']}: $value contributions'),
                                ],
                              ),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: currentScheme?.level4 ?? Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // Features showcase
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✨ Enhanced Features',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      _buildFeatureChip('Smooth Animations', Icons.animation),
                      _buildFeatureChip('Hover Effects', Icons.touch_app),
                      _buildFeatureChip('Multiple Themes', Icons.palette),
                      _buildFeatureChip('Statistics', Icons.analytics),
                      _buildFeatureChip('Responsive', Icons.devices),
                      _buildFeatureChip('Pulse Animation', Icons.favorite),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(String label, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.w, color: Theme.of(context).colorScheme.primary),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  /// Generate more realistic contribution data
  List<List<int>> _generateRealisticData() {
    final random = Random(42);
    return List.generate(52, (week) {
      return List.generate(7, (day) {
        // Simulate realistic patterns: less on weekends, some breaks
        if (day == 0 || day == 6) {
          // Weekends - lower activity
          return random.nextBool() ? 0 : random.nextInt(3);
        } else {
          // Weekdays - higher activity with some variation
          final baseActivity = random.nextInt(5);
          // Simulate vacation weeks (every 8-12 weeks)
          if (week % 10 == 0 && random.nextBool()) {
            return 0; // Vacation week
          }
          return baseActivity;
        }
      });
    });
  }

  /// Calculate total contributions from data
  int _calculateTotal(List<List<int>> data) {
    int total = 0;
    for (final week in data) {
      for (final day in week) {
        total += day;
      }
    }
    return total;
  }
}