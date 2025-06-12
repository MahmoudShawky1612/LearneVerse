import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class NoDataWidget<T> extends StatelessWidget {
  final String message;
  final String? lottieUrl;
  final double? width;
  final double? height;

  const NoDataWidget({
    super.key,
    required this.message,
    this.lottieUrl = 'https://lottie.host/897f191d-1257-4c7a-9cf3-e780e06cf0b8/DPdpOIc0Za.json',
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 800),
              child: lottieUrl != null
                  ? Lottie.network(
                lottieUrl!,
                width: width ?? 200.w,
                height: height ?? 200.h,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.hourglass_empty,
                  size: 50.sp,
                  color: Colors.redAccent,
                ),
              )
                  : Icon(
                Icons.info_outline,
                size: 100.sp,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.blueAccent,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}