import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../discover/presentation/widgets/vertical_users_list.dart';
import '../../../profile/presentation/widgets/vertical_community_list.dart';

class BuildSearchResults extends StatelessWidget {
  final communities;
  final users;
  final owners;

  const BuildSearchResults(
      {super.key, required this.communities, required this.users, required this.owners});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 0,
        right: 0,
        top: 250,
        child: Center(
          child: Container(
            width: 380,
            height: 500,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(22),
                  topLeft: Radius.circular(22),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    spreadRadius: 0,
                    offset: const Offset(0, 6),
                  ),
                ],
                color: Colors.white),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  VerticalCommunityList(
                    communities: communities,
                  ),
                  VerticalUserList(users: users),
                  VerticalUserList(users: owners),
                ],
              ),
            ),
          ),
        ));
  }
}
