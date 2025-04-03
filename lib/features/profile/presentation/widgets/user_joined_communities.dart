import 'package:flutter/cupertino.dart';
import 'package:flutterwidgets/features/profile/presentation/widgets/vertical_community_list.dart';

import '../../../home/models/community_model.dart';

class UserJoinedCommunities extends StatelessWidget {
  UserJoinedCommunities({super.key});

  final List<Community> userCommunities = Community.generateDummyCommunities();

  @override
  Widget build(BuildContext context) {
    return VerticalCommunityList(
      communities: userCommunities,
    );
  }
}
