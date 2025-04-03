import 'package:flutter/cupertino.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';

class BuildSectionTitle extends StatelessWidget {
  final title;

  const BuildSectionTitle({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
