import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../home/models/author_model.dart';
import '../../../profile/presentation/views/profile_screen.dart';

class UserItem extends StatelessWidget {
  final user;
  final Color _accentColor = const Color(0xFF00B2FF);

  const UserItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final String role = user.role;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2D3748),
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
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9F9F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              role,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: role == "Member"
                                    ? AppColors.textPrimary
                                    : AppColors.accent,
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
                    gradient: AppColors.backgroundGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Find the user by their username or another unique identifier
                      List<Author> users = Author.users;
                      final selectedUser = users
                          .firstWhere((u) => u.userName == user.userName);

                      // Navigate to the profile screen with the selected user
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(userInfo: selectedUser),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: const Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        "Profile",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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
}
