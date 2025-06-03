import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'profile_social_button.dart';

class ProfileSocialLinksRow extends StatelessWidget {
  const ProfileSocialLinksRow({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Padding(
      padding:   EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProfileSocialButton(
            icon: FontAwesomeIcons.github,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('GitHub Profile')),
              );
            },
          ),
            SizedBox(width: 16.w),
          ProfileSocialButton(
            icon: FontAwesomeIcons.linkedin,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('LinkedIn Profile')),
              );
            },
          ),
            SizedBox(width: 16.w),
          ProfileSocialButton(
            icon: FontAwesomeIcons.facebook,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Facebook Profile')),
              );
            },
          ),
            SizedBox(width: 16.w),
          ProfileSocialButton(
            icon: FontAwesomeIcons.twitter,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Twitter Profile')),
              );
            },
          ),
        ],
      ),
    );
  }
}
