import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileBioQuote extends StatelessWidget {
  final userInfo;

  const ProfileBioQuote({super.key, this.userInfo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: colorScheme.onPrimary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.format_quote,
            color: colorScheme.onPrimary.withOpacity(0.8),
            size: 18.r,
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              userInfo?.quote ?? "كَلَّا إِنَّ مَعِيَ رَبِّي سَيَهْدِينِ",
              style: TextStyle(
                fontSize: 15.sp,
                fontStyle: FontStyle.italic,
                color: colorScheme.onPrimary.withOpacity(0.9),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
