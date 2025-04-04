import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';

class ProfileAvatarAndName extends StatelessWidget {
  final  userInfo;
  ProfileAvatarAndName({super.key, this.userInfo});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.backgroundLight, width: 3),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textSecondary.withOpacity(0.15),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child:  CircleAvatar(
                backgroundImage:AssetImage(userInfo?.avatar ?? 'assets/images/avatar.jpg'),
                radius: 36,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.upVote,
                  border: Border.all(color: AppColors.backgroundLight, width: 2),
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
               userInfo?.name ?? "Dodje Shawky",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.backgroundLight,
                  letterSpacing: -0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
            ],
          ),
        ),
      ],
    );
  }
}