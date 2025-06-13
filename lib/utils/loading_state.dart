import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class LoadingState extends StatelessWidget {
  final Color? backgroundColor;
  final bool showText;

  const LoadingState({
    super.key,
    this.backgroundColor,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: theme.colorScheme.background,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 70.w,
              height: 70.h,
              child: Lottie.network(
                "https://lottie.host/64b54aab-3736-4af8-8032-19a2f8889a36/gdmbgRDEAK.json",
                fit: BoxFit.contain,
                repeat: true,
                errorBuilder: (context, error, stackTrace) {
                  return CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
