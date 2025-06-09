import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/features/discover/logic/cubit/toggle_cubit.dart';
import 'package:flutterwidgets/features/discover/logic/cubit/toggle_states.dart';
import 'package:flutterwidgets/features/home/data/models/community_model.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/url_helper.dart';
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

    // Use ValueNotifier to track the favorite state locally
    final isFavoritedNotifier = ValueNotifier<bool>(isFavoriteCommunity);

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
                child: _buildCommunityImage(theme, colorScheme),
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
              _buildViewButton(context, colorScheme, themeExtension),
            ],
          ),

          // Favorite Button
          if (isFavoriteCommunity)
            BlocProvider<ToggleCubit>(
              create: (BuildContext context) => ToggleCubit(ToggleService()),
              child: Positioned(
                top: 8.h,
                right: 8.w,
                child: BlocConsumer<ToggleCubit, ToggleStates>(
                  listener: (context, state) {
                    if (state is ToggleToggled) {
                      // Toggle the local favorite state
                      isFavoritedNotifier.value = !isFavoritedNotifier.value;
                      // Notify parent widget if callback is provided
                      onFavoriteToggle?.call();
                    } else if (state is ToggleError) {
                      // Show error message (e.g., via a SnackBar)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  builder: (context, state) {
                    bool isLoading = state is ToggleLoading;

                    return ValueListenableBuilder<bool>(
                      valueListenable: isFavoritedNotifier,
                      builder: (context, isFavorited, child) {
                        return _buildFavoriteButton(
                          context,
                          colorScheme,
                          isFavorited,
                          isLoading,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCommunityImage(ThemeData theme, ColorScheme colorScheme) {
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

  Widget _buildViewButton(BuildContext context, ColorScheme colorScheme,
      AppThemeExtension? themeExtension) {
    return Container(
      width: double.infinity,
      height: 36.h,
      margin: EdgeInsets.fromLTRB(8.w, 0, 8.w, 8.w),
      decoration: BoxDecoration(
        gradient: themeExtension?.buttonGradient ??
            LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primary,
                colorScheme.primary.withOpacity(0.8),
              ],
            ),
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.25),
            blurRadius: 8,
            spreadRadius: -1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/community', extra: community),
          borderRadius: BorderRadius.circular(18.r),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'View',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: colorScheme.onPrimary,
                  size: 12.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(
      BuildContext context,
      ColorScheme colorScheme,
      bool isFavorited,
      bool isLoading,
      ) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            colorScheme.surface.withOpacity(0.95),
            colorScheme.surface.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: isFavorited
                ? colorScheme.primary.withOpacity(0.2)
                : colorScheme.onSurface.withOpacity(0.1),
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: colorScheme.onSurface.withOpacity(0.08),
            blurRadius: 3,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading
              ? null
              : () {
            context.read<ToggleCubit>().toggleToggleCommunity(community.id);
          },
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            padding: EdgeInsets.all(6.w),
            child: isLoading
                ? SizedBox(
              width: 18.r,
              height: 18.r,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorScheme.primary,
              ),
            )
                : isFavorited
                ? ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [
                    Colors.red.shade400,
                    Colors.pink.shade600,
                  ],
                ).createShader(bounds);
              },
              child: Icon(
                Icons.favorite,
                color: Colors.white,
                size: 18.r,
              ),
            )
                : Icon(
              Icons.favorite_border,
              color: colorScheme.onSurface.withOpacity(0.6),
              size: 18.r,
            ),
          ),
        ),
      ),
    );
  }
}