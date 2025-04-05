import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
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
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    user.avatar,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            "@${user.userName}",
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              role,
                              style: TextStyle(
                                fontSize: 12,
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
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    gradient: themeExtension?.buttonGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Navigate to profile based on user type
                      navigateToProfile(context);
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        "Profile",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  void navigateToProfile(BuildContext context) {
    // Check if user is an Owner type or Author type
    if (user is Owner) {
      // Create a compatible Author object for the Owner
      final ownerUser = user as Owner;
      final authorFromOwner = Author(
        id: ownerUser.id,
        name: ownerUser.name,
        avatar: ownerUser.avatar,
        userName: ownerUser.userName,
        role: ownerUser.role,
        points: 0, // Default values for required fields
        joinedCommunities: [], // Empty list as a default
        quote: "Owner of communities", // Default quote for owners
        totalJoinedCommunities: 0,
        totalPostUpvotes: 0,
        totalCommentUpvotes: 0,
      );
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(userInfo: authorFromOwner),
        ),
      );
    } else {
      // Regular Author user
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
        // Fallback for user not found
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile not available')),
        );
      }
    }
  }
}
