
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/features/discover/logic/cubit/toggle_cubit.dart';
import 'package:flutterwidgets/features/home/data/models/community_model.dart';
import '../../../discover/presentation/widgets/community_image.dart';
import '../../../discover/presentation/widgets/heart_button.dart';
import '../../../discover/presentation/widgets/view_button.dart';
import '../../../discover/services/toggle_service.dart';

class CommunityItem extends StatelessWidget {
  final Community community;
  final bool isFavoriteCommunity;
  final VoidCallback? onFavoriteToggle;

  const CommunityItem({
    super.key,
    required this.community,
    this.isFavoriteCommunity = false,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final themeExtension = theme.extension<AppThemeExtension>();

    final itemWidth = 140.0.w;

    final isFavoritedNotifier = ValueNotifier<bool>(isFavoriteCommunity);
    final isFavoriteButtonEnabled = ValueNotifier<bool>(true);

    return Container(
      width: itemWidth,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.08),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: colorScheme.onSurface.withOpacity(0.05),
            blurRadius: 6,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.7],
              ),
            ),
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Community Image
              Padding(
                padding: EdgeInsets.only(top: 16.w, bottom: 8.w),
                child: CommunityImage(
                  community: community,
                  theme: theme,
                  colorScheme: colorScheme,
                ),
              ),

              // Community Name
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                child: Text(
                  community.name,
                  style: textTheme.titleMedium?.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.2.h,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              SizedBox(height: 12.w),

              // View Button
              ViewButton(
                community: community,
                colorScheme: colorScheme,
                themeExtension: themeExtension,
              ),
            ],
          ),

          // Favorite Button
          if (isFavoriteCommunity)
            BlocProvider<ToggleCubit>(
              create: (BuildContext context) => ToggleCubit(ToggleService()),
              child: Positioned(
                top: 8.h,
                right: 8.w,
                child: FavoriteButton(
                  community: community,
                  isFavoritedNotifier: isFavoritedNotifier,
                  isFavoriteButtonEnabled: isFavoriteButtonEnabled,
                  colorScheme: colorScheme,
                  onFavoriteToggle: onFavoriteToggle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

