import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterwidgets/features/home/data/models/community_model.dart';
import 'package:flutterwidgets/features/profile/presentation/widgets/vertical_community_list.dart';
import '../../logic/cubit/user_communities_cubit.dart';
import '../../logic/cubit/user_communities_states.dart';

class UserJoinedCommunities extends StatelessWidget {
  final List<Community> communities;
  final int userId;

  const UserJoinedCommunities({super.key, required this.communities, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCommunitiesCubit, UserCommunitiesState>(
      listener: (context, state) {
        if (state is UserCommunitiesActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is UserCommunitiesActionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: VerticalCommunityList(
        communities: communities,
        onLeave: (ctx, community) {
          ctx.read<UserCommunitiesCubit>().leaveCommunity(userId, community.id);
        },
      ),
    );
  }
}
