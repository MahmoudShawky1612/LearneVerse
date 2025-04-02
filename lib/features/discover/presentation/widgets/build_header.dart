import 'package:flutter/cupertino.dart';

class BuildHeader extends StatelessWidget {
  const BuildHeader({super.key});
  final Color _textColor = const Color(0xFF2D3748);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Discover",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: _textColor,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Communities, people and more...",
          style: TextStyle(
            fontSize: 16,
            color: _textColor.withOpacity(0.7),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );

  }
}

