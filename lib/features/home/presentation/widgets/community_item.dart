import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class CommunityItem extends StatelessWidget {
  final dynamic community;

  const CommunityItem({
    super.key,
    required this.community,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();

    // Responsive width based on screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth < 360 ? 130.0 : 140.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: itemWidth,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withOpacity(0.08),
            blurRadius: 6,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top content section
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 6),
            child: _buildCommunityIcon(colorScheme),
          ),

          // Community name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Text(
              community.name,
              style: textTheme.titleMedium?.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Member count
          _buildMemberCount(colorScheme, textTheme),

          const SizedBox(height: 8),

          // View button
          _buildViewButton(context, colorScheme, themeExtension),
        ],
      ),
    );
  }

  Widget _buildCommunityIcon(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withOpacity(0.05),
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Image(
        image: AssetImage(community.image),
        width: 40,
        height: 40,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildMemberCount(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            FontAwesomeIcons.userFriends,
            size: 9,
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(width: 4),
          Text(
            '${community.memberCount}',
            style: textTheme.bodySmall?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewButton(
      BuildContext context,
      ColorScheme colorScheme,
      AppThemeExtension? themeExtension
      ) {
    return Container(
      width: double.infinity,
      height: 32,
      margin: const EdgeInsets.fromLTRB(6, 0, 6, 6),
      decoration: BoxDecoration(
        gradient: themeExtension?.buttonGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/community', extra: community),
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'View',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: colorScheme.onPrimary,
                  size: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}