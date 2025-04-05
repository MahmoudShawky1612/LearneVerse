import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';

class ProfileBioQuote extends StatelessWidget {
  final userInfo;

  ProfileBioQuote({super.key, this.userInfo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.onPrimary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.format_quote,
            color: colorScheme.onPrimary.withOpacity(0.8),
            size: 18,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              userInfo?.quote ?? "كَلَّا إِنَّ مَعِيَ رَبِّي سَيَهْدِينِ",
              style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: colorScheme.onPrimary.withOpacity(0.9),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
