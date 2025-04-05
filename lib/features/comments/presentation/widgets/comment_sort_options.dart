import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';

class CommentSortOptions extends StatelessWidget {
  const CommentSortOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Sort Comments By', 
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: colorScheme.onBackground,
            )
          ),
          _buildSortOption(context, 'Most Recent', Icons.access_time),
          _buildSortOption(context, 'Top Comments', Icons.thumb_up),
        ],
      ),
    );
  }

  Widget _buildSortOption(BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(
        title,
        style: TextStyle(color: colorScheme.onSurface),
      ),
      onTap: () => Navigator.pop(context),
    );
  }
}
