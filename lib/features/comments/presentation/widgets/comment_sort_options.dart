import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


class CommentSortOptions extends StatelessWidget {
  const CommentSortOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding:   EdgeInsets.symmetric(vertical: 20.w),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius:   BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Sort Comments By', 
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              color: colorScheme.onSurface,
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
