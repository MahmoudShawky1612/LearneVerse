import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'options_item.dart';

class OptionsMenu extends StatelessWidget {
  final double maxWidth;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const OptionsMenu({
    super.key,
    required this.maxWidth,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(top: 8.h),
      constraints: BoxConstraints(
        maxWidth: (maxWidth * 0.6).clamp(140.0, 220.0),
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.15),
            blurRadius: 10.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          OptionsItem(
            text: 'Edit',
            icon: Icons.edit_outlined,
            color: colorScheme.primary,
            onTap: onEdit,
          ),
          Divider(
            height: 1.h,
            color: colorScheme.onSurface.withOpacity(0.1),
          ),
          OptionsItem(
            text: 'Delete',
            icon: Icons.delete_outline,
            color: colorScheme.error,
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}
