import 'package:flutter/cupertino.dart';
import 'package:flutterwidgets/features/discover/presentation/widgets/build_filter_chip.dart';

class BuildFiltersList extends StatelessWidget {
  BuildFiltersList({super.key});
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
    return SizedBox(
      height: 45,
      child: ListView.builder(
        itemCount: _filters.length,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 2),
        itemBuilder: (context, index) {
          return BuildFilterChip(index:index);
        },
      ),
    );
  }
}