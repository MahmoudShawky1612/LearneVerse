import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BuildFilterChip extends StatelessWidget {
  final index;
   BuildFilterChip({super.key, this.index});
  final Color _primaryColor = const Color(0xFFFF4B91);
  final Color _textColor = const Color(0xFF2D3748);

  final List<String> _filters = [
    'C',
    'Java',
    'Data Structure',
    'Algorithms',
    'Operating System',
    'Database',
    'Problem Solving',
    'Go Lang',
    'Flutter',
    'TypeScript',
    'Node.js'
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Filter selection logic would go here
          },
          splashColor: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 110,
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            decoration: BoxDecoration(
              color: _primaryColor,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: _primaryColor.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  blurRadius: 0,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _filters[index],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );

  }
}
