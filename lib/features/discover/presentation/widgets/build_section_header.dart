import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BuildSectionHeader extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback onTap;

  const BuildSectionHeader({super.key, required this.title, required this.isExpanded, required this.onTap});
  final Color _textColor = const Color(0xFF2D3748);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: onTap,
            icon: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 28,
              color: _textColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );

  }
}
