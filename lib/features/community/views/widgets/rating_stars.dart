import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final int reviews;

  const RatingStars({super.key, required this.rating, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(5, (index) {
        return Icon(
          index < rating.floor()
              ? Icons.star
              : (index == rating.floor() && rating % 1 > 0)
                  ? Icons.star_half
                  : Icons.star_border,
          color: Colors.amber,
          size: 18.w,
        );
      }),
    );
  }
}
