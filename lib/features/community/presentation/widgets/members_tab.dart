import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/community/logic/cubit/community_members_cubit.dart';
import 'package:flutterwidgets/features/discover/presentation/widgets/vertical_users_list.dart';

import '../../logic/cubit/community_members_state.dart';

class MembersTab extends StatefulWidget {
  final dynamic community;
  final TextEditingController searchController;
  final void Function(String) onSearch;

  const MembersTab({
    super.key,
    required this.community,
    required this.searchController,
    required this.onSearch,
  });

  @override
  State<MembersTab> createState() => _MembersTabState();
}

class _MembersTabState extends State<MembersTab> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<CommunityMembersCubit>().fetchCommunityMembers(widget.community.id);
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'All Members',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            BlocBuilder<CommunityMembersCubit, CommunityMembersStates>(
              builder: (BuildContext context, state) {
                if (state is CommunityMembersLoading) {
                  return const CupertinoActivityIndicator();
                } else if (state is CommunityMembersError) {
                  return Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  );
                } else if (state is CommunityMembersSuccess) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '${state.members.length} members',
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        SizedBox(height: 16.h),
        BlocBuilder<CommunityMembersCubit, CommunityMembersStates>(
          builder: (context, state) {
            if (state is CommunityMembersLoading) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (state is CommunityMembersError) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.red)),
              );
            } else if (state is CommunityMembersSuccess) {
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: VerticalUserList(users: state.members),
                  ),
                  SizedBox(height: 24.h),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}