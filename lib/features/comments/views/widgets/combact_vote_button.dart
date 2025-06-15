import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompactVoteButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool isLoading;
  final VoidCallback onTap;

  const CompactVoteButton({
    required this.icon,
    required this.color,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(5.r),
        child: isLoading
            ? SizedBox(
          width: 14.r,
          height: 14.r,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        )
            : Icon(
          icon,
          size: 16.r,
          color: color,
        ),
      ),
    );
  }
}
