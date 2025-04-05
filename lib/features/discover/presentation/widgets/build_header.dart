import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class BuildHeader extends StatelessWidget {
  const BuildHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Discover",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: colorScheme.onBackground,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Communities, people and more...",
          style: TextStyle(
            fontSize: 16,
            color: colorScheme.onBackground.withOpacity(0.7),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
