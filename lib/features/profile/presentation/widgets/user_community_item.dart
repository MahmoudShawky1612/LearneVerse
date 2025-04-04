  import 'package:flutter/material.dart';
  import 'package:flutterwidgets/core/constants/app_colors.dart';
  import 'package:flutterwidgets/features/home/models/community_model.dart';
  import 'package:font_awesome_flutter/font_awesome_flutter.dart';

  class UserCommunityItem extends StatelessWidget {
    final Community community;
    final bool isJoined;
    final VoidCallback? onTap;
    final VoidCallback? onJoinLeave;

    const UserCommunityItem({
      super.key,
      required this.community,
      this.isJoined = true,
      this.onTap,
      this.onJoinLeave,
    });

    @override
    Widget build(BuildContext context) {
      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: _buildShadowDecoration(),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildCommunityImage(),
                  const SizedBox(width: 16),
                  _buildCommunityDetails(),
                  const SizedBox(width: 12),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      );
    }

    BoxDecoration _buildShadowDecoration() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    );

    Widget _buildCommunityImage() => Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.asset(
          community.image,
          width: 69,
          height: 70,
          fit: BoxFit.cover,
        ),
      ),
    );

    Widget _buildCommunityDetails() => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            community.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D3748),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 5,
            runSpacing: 2,
            children: [
              _buildMemberCount(),
              _buildPrivacyBadge(),
            ],
          ),
        ],
      ),
    );

    Widget _buildMemberCount() => _buildBadge(
      color: const Color(0xFFEBF5FF),
      textColor: Colors.blue.shade700,
      icon: FontAwesomeIcons.userFriends,
      label: '${community.memberCount}',
    );

    Widget _buildPrivacyBadge() => _buildBadge(
      color: const Color(0xFFF9F9F9),
      textColor: community.communityPrivacy == "Public" ? AppColors.upVote : AppColors.downVote,
      icon: community.communityPrivacy == "Public" ? FontAwesomeIcons.lockOpen : FontAwesomeIcons.lock,
      label: community.communityPrivacy,
      fontSize: 10,
    );
    Widget _buildBadge({
      required Color color,
      required Color textColor,
      required IconData icon,
      required String label,
      double fontSize = 12,
    }) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: fontSize + 1, color: textColor),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: textColor,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );

    Widget _buildActionButtons() => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: AppColors.buttonGradient,
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isJoined ? "View" : "Join",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (isJoined)
          TextButton(
            onPressed: onJoinLeave,
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            child: const Text("Leave Group"),
          ),
      ],
    );
  }