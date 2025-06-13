import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildHeader extends StatelessWidget {
  const BuildHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Discover",
              style: GoogleFonts.poppins(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
           Spacer(),
           Icon(
             //planet earth icon from Material Icons
               Icons.public,
             color: colorScheme.onSurface,
              size: 24.r,
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          "Communities, people and more...",
          style: TextStyle(
            fontSize: 16.sp,
            color: colorScheme.onSurface.withOpacity(0.7),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
