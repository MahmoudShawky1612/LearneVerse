import 'package:flutter/cupertino.dart';
import 'package:flutterwidgets/features/home/data/models/community_model.dart';
import 'package:flutterwidgets/features/profile/presentation/widgets/vertical_community_list.dart';

import '../../../home/models/author_model.dart';

class UserJoinedCommunities extends StatelessWidget {
  final List<Community> communities;

  const UserJoinedCommunities({super.key, required this.communities});

  @override
  Widget build(BuildContext context) {

    return VerticalCommunityList(
      communities: communities,
    );
  }
}
