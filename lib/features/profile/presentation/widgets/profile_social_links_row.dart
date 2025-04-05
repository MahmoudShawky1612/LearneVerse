import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'profile_social_button.dart';

class ProfileSocialLinksRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
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
          const SizedBox(width: 16),
          ProfileSocialButton(
            icon: FontAwesomeIcons.linkedin,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('LinkedIn Profile')),
              );
            },
          ),
          const SizedBox(width: 16),
          ProfileSocialButton(
            icon: FontAwesomeIcons.facebook,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Facebook Profile')),
              );
            },
          ),
          const SizedBox(width: 16),
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
