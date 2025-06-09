import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/profile/data/models/user_profile_model.dart';

class ProfileBioQuote extends StatelessWidget {
  final UserProfile userInfo;

  const ProfileBioQuote({super.key, required this.userInfo});

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
              userInfo.bio ?? "كَلَّا إِنَّ مَعِيَ رَبِّي سَيَهْدِينِ",
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
