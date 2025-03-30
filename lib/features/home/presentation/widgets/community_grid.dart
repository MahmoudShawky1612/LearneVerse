import 'package:flutter/cupertino.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/community_item.dart';

class CommunityGrid extends StatelessWidget {
  const CommunityGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        itemCount: 15,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return const CommunityItem(
              title: "Data Structure", image: "assets/images/flutter.jpg");
        },
      ),
    );
  }
}
