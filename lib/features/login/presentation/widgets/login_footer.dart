import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
        ),
        TextButton(
          onPressed: () {
            // Navigate to sign up
          },
          child: Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF3B82F6),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
