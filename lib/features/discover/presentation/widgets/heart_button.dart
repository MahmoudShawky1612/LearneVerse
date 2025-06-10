import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/snackber_util.dart';
import '../../../home/data/models/community_model.dart';
import '../../logic/cubit/toggle_cubit.dart';
import '../../logic/cubit/toggle_states.dart';
import 'loading_heart_animation.dart';
class FavoriteButton extends StatelessWidget {
  final Community community;
  final ValueNotifier<bool> isFavoritedNotifier;
  final ValueNotifier<bool> isFavoriteButtonEnabled;
  final ColorScheme colorScheme;
  final VoidCallback? onFavoriteToggle;

  const FavoriteButton({
    super.key,
    required this.community,
    required this.isFavoritedNotifier,
    required this.isFavoriteButtonEnabled,
    required this.colorScheme,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToggleCubit, ToggleStates>(
      listener: (context, state) {
        if (state is ToggleToggled) {
          isFavoritedNotifier.value = false; // Unfavorite it
          isFavoriteButtonEnabled.value = false; // Disable button
          onFavoriteToggle?.call();
          SnackBarUtils.showInfoSnackBar(context, message: "Community Marked as not Favorite 😢");
        } else if (state is ToggleError) {
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
            return _FavoriteButtonContent(
              community: community,
              isFavorited: isFavorited,
              isLoading: isLoading,
              isFavoriteButtonEnabled: isFavoriteButtonEnabled,
              colorScheme: colorScheme,
            );
          },
        );
      },
    );
  }
}
class _FavoriteButtonContent extends StatelessWidget {
  final Community community;
  final bool isFavorited;
  final bool isLoading;
  final ValueNotifier<bool> isFavoriteButtonEnabled;
  final ColorScheme colorScheme;

  const _FavoriteButtonContent({
    required this.community,
    required this.isFavorited,
    required this.isLoading,
    required this.isFavoriteButtonEnabled,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
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
          onTap: (isLoading || !isFavoriteButtonEnabled.value)
              ? null
              : () {
            context.read<ToggleCubit>().toggleToggleCommunity(community.id);
          },
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            padding: EdgeInsets.all(6.w),
            child: isLoading
                ? LoadingHeartAnimation(size: 18.r)
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
