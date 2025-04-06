import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../community/models/owner_model.dart';
import '../../../home/models/author_model.dart';
import '../../../home/models/community_model.dart';
import '../../../profile/presentation/views/profile_screen.dart';

class UserItem extends StatelessWidget {
  final user;

  const UserItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final String role = user.role;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final themeExtension = theme.extension<AppThemeExtension>();
    final screenWidth = MediaQuery.of(context).size.width;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 600),
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: context.h(8),
          horizontal: context.w(16),
        ),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.all(context.w(8)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      user.avatar,
                      width: screenWidth > 600 ? 60 : context.w(50),
                      height: screenWidth > 600 ? 60 : context.w(50),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: context.w(8)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          user.name,
                          style: textTheme.bodyLarge?.copyWith(
                            fontSize: context.fontSize(16),
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: context.h(4)),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "@${user.userName}",
                                style: TextStyle(
                                  fontSize: context.fontSize(14),
                                  color: colorScheme.onSurface.withOpacity(0.7),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: context.w(5)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.w(8),
                                vertical: context.h(4),
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                role,
                                style: TextStyle(
                                  fontSize: context.fontSize(12),
                                  fontWeight: FontWeight.w600,
                                  color: role == "Member"
                                      ? colorScheme.onSurface
                                      : colorScheme.tertiary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (screenWidth > 400) ...[
                    SizedBox(width: context.w(8)),
                    Flexible(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 100),
                        decoration: BoxDecoration(
                          gradient: themeExtension?.buttonGradient,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () => navigateToProfile(context),
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.w(10),
                              vertical: context.h(6),
                            ),
                            child: Text(
                              "Profile",
                              style: TextStyle(
                                fontSize: context.fontSize(10),
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void navigateToProfile(BuildContext context) {
    if (user is Owner) {
      final ownerUser = user as Owner;
      final authorFromOwner = Author(
        id: ownerUser.id,
        name: ownerUser.name,
        avatar: ownerUser.avatar,
        userName: ownerUser.userName,
        role: ownerUser.role,
        points: 0,
        joinedCommunities: [],
        quote: "Owner of communities",
        totalJoinedCommunities: 0,
        totalPostUpvotes: 0,
        totalCommentUpvotes: 0,
        interests: [],
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(userInfo: authorFromOwner),
        ),
      );
    } else {
      try {
        List<Author> users = Author.users;
        final selectedUser = users.firstWhere((u) => u.userName == user.userName);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(userInfo: selectedUser),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile not available')),
        );
      }
    }
  }
}