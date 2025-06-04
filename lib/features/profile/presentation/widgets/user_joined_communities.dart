import 'package:flutter/cupertino.dart';
import 'package:flutterwidgets/features/profile/presentation/widgets/vertical_community_list.dart';

import '../../../home/models/author_model.dart';

class UserJoinedCommunities extends StatelessWidget {
  final userInfo;

  const UserJoinedCommunities({super.key, this.userInfo});

  @override
  Widget build(BuildContext context) {
    
    final communities =
        userInfo?.joinedCommunities ?? Author.userJoinedCommunities;

    return VerticalCommunityList(
      communities: communities,
    );
  }
}
