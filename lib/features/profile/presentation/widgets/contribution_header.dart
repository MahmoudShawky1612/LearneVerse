import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'contributions.dart';

class ContributionHeader extends StatelessWidget {
  const ContributionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      width: double.infinity,
      margin:   EdgeInsets.only(top: 20.h),
      padding:   EdgeInsets.all(15.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Yearly Contributions",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
            SizedBox(height: 5.h),
          Text(
            "364 contributions in the last year",
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
            SizedBox(height: 15.h),
            SizedBox(
            height: 130.h,
            child: const YearContributionChart(),
          ),
            SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Less",
                  style: TextStyle(fontSize: 12.sp, color: colorScheme.onSurface.withOpacity(0.6))),
                SizedBox(width: 4.w),
              Container(
                height: 10.h,
                width: 10.w,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
                SizedBox(width: 2.w),
              Container(
                height: 10.h,
                width: 10.w,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
                SizedBox(width: 2.w),
              Container(
                height: 10.h,
                width: 10.w,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
                SizedBox(width: 2.w),
              Container(
                height: 10.h,
                width: 10.w,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
                SizedBox(width: 2.w),
              Container(
                height: 10.h,
                width: 10.w,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
                SizedBox(width: 4.w),
              Text("More",
                  style: TextStyle(fontSize: 12.sp, color: colorScheme.onSurface.withOpacity(0.6))),
            ],
          ),
        ],
      ),
    );
  }
}
