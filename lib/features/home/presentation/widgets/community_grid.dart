import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/home/logic/cubit/community_cubit.dart';
import 'package:flutterwidgets/features/home/logic/cubit/community_states.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/community_item.dart';

class CommunityGrid extends StatefulWidget {
  final communities;

  const CommunityGrid({super.key, required this.communities});

  @override
  State<CommunityGrid> createState() => _CommunityGridState();
}

class _CommunityGridState extends State<CommunityGrid> {
  @override
  void initState() {
    super.initState();
    context.read<CommunityCubit>().fetchCommunities();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityCubit, CommunityStates>(
      builder: (BuildContext context, CommunityStates state)
    {
      if (state is CommunityLoading) {
        return const Center(child: CupertinoActivityIndicator());
      } else if (state is CommunityFailure) {
        return Center(child: Text(state.message));
      } else if (state is CommunitySuccess) {
        return SizedBox(
          height: 155.h,
          child: ListView.builder(
            itemCount: state.communities.length > 7 ? 7 : state.communities.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return CommunityItem(
                community: state.communities[index],
              );
            },
      ),
        );
      }
      return const Center(child: Text('Unknown state'));
    },
    );
  }
}
