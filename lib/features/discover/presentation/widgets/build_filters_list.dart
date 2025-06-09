import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'build_filter_chip.dart';

class BuildFiltersList extends StatelessWidget {
  final List<String> selectedFilters;
  final Function(String) onFilterToggle;

  BuildFiltersList({
    super.key,
    this.selectedFilters = const [],
    required this.onFilterToggle,
  });

  final List<String> filters = [
    'backend',
    'go lang',
    'cloud',
    'c',
    'problem solving',
    'intermediate',
    'advanced',
    'node.js',
    'popular',
    'database',
    'react',
    'new',
    'typescript'
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 27.h,
      child: ListView.builder(
        itemCount: filters.length,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        itemBuilder: (context, index) {
          return BuildFilterChip(
            index: index,
            filters: filters,
            isSelected: selectedFilters.contains(filters[index]),
            onToggle: onFilterToggle,
          );
        },
      ),
    );
  }
}
