import 'package:flutter/cupertino.dart';

class BuildSectionTitle extends StatelessWidget {
  final title;
  const BuildSectionTitle({super.key, this.title});
  final Color _textColor = const Color(0xFF2D3748);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: _textColor,
        ),
      ),
    );

  }
}
