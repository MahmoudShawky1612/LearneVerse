import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return   Center(
      child: SizedBox(
        width: 70.w,
        child: Lottie.network("https://lottie.host/64b54aab-3736-4af8-8032-19a2f8889a36/gdmbgRDEAK.json",
          fit: BoxFit.contain,
          repeat: true,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.circle_outlined,
              size: 48.sp,
              color: Colors.blue,
            );
          },
        ),
      ),
    );
  }
}