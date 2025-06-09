import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/discover/logic/cubit/favorite_communities_cubit.dart';
import 'package:flutterwidgets/features/discover/logic/cubit/favorite_communities_states.dart';
import 'package:flutterwidgets/features/discover/presentation/widgets/build_section_header.dart';
import '../../../home/presentation/widgets/community_grid.dart';

class BuildDefaultContent extends StatefulWidget {
  const BuildDefaultContent({super.key});

  @override
  State<BuildDefaultContent> createState() => _BuildDefaultContentState();
}

bool _isFavoriteExpanded = true;
class _BuildDefaultContentState extends State<BuildDefaultContent> {

  @override
  void initState() {
    super.initState();
    context.read<FavoriteCubit>().fetchFavoriteCommunities();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          BuildSectionHeader(
            title: "Favorite Communities",
            isExpanded: _isFavoriteExpanded,
            onTap: () {
              setState(() {
                _isFavoriteExpanded = !_isFavoriteExpanded;
              });
            },
          ),
          if (_isFavoriteExpanded) BlocBuilder<FavoriteCubit, FavoriteStates>(
              builder: (BuildContext context, FavoriteStates state) {
            if (state is FavoriteLoading) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (state is FavoriteLoaded) {
              if (state.communities.isEmpty) {
                return const Center(child: Text("You have no favorite communities yet 🧐"));
              }
              return CommunityGrid(communities: state.communities);
            } else if (state is FavoriteError) {
              return Center(child: Text(state.message));
            }
            return const Center();
              }
          ),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }
}
