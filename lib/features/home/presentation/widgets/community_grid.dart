import 'package:flutter/cupertino.dart';
import 'package:flutterwidgets/features/home/models/community_model.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/community_item.dart';

class CommunityGrid extends StatelessWidget {
  final communities;

  const CommunityGrid({super.key, required this.communities});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        itemCount: communities.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return CommunityItem(
            community: communities[index],
          );
        },
      ),
    );
  }
}
