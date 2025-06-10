import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/url_helper.dart';
import '../../../home/data/models/community_model.dart';

class CommunityImage extends StatelessWidget {
  final Community community;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const CommunityImage({
    super.key,
    required this.community,
    required this.theme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withOpacity(0.1),
            colorScheme.secondary.withOpacity(0.05),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.15),
            blurRadius: 8,
            spreadRadius: -1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(4.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Image.network(
          UrlHelper.transformUrl(community.logoImgURL),
          width: 42.w,
          height: 42.h,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 42.w,
              height: 42.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.surfaceVariant,
                    colorScheme.surfaceVariant.withOpacity(0.7),
                  ],
                ),
              ),
              child: Icon(
                Icons.group,
                size: 24.r,
                color: colorScheme.primary.withOpacity(0.7),
              ),
            );
          },
        ),
      ),
    );
  }
}
