import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

Widget noProfileDataWidget() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Lottie Animation
        AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 800),
          child: Lottie.network(
            'https://lottie.host/897f191d-1257-4c7a-9cf3-e780e06cf0b8/DPdpOIc0Za.json',
            width: 200.w, // Responsive width
            height: 200.h, // Responsive height
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.error_outline,
              size: 50.sp,
              color: Colors.redAccent,
            ),
          ),
        ),
        SizedBox(height: 16.h), // Responsive spacing
        // Text with modern styling
        Text(
          'No profile data yet! 👀',
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: Colors.blueAccent,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}