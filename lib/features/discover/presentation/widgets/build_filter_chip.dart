import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/features/home/models/community_model.dart';

class BuildFilterChip extends StatelessWidget {
  final int index;

  BuildFilterChip({super.key, required this.index});

  final List<String> _filters = [
    'beginner',
    'go lang',
    'angular',
    'c' ,
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
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            print(_filters[index]);
          },
          splashColor: AppColors.primary.withOpacity(0.3),
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 110,
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primaryDark,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: AppColors.backgroundLight.withOpacity(0.1),
                  blurRadius: 4,
                  spreadRadius: 0,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _filters[index],
                style: const TextStyle(
                  color: AppColors.backgroundLight,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}