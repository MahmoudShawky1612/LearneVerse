import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/discover/logic/cubit/favorite_communities_cubit.dart';
import 'package:flutterwidgets/features/discover/logic/cubit/favorite_communities_states.dart';
import 'package:flutterwidgets/features/discover/views/widgets/build_section_header.dart';
import 'package:flutterwidgets/utils/error_state.dart';
import 'package:flutterwidgets/utils/loading_state.dart';
import '../../../home/views/widgets/community_grid.dart';
import '../../../profile/views/widgets/no_profile_widget.dart';

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
    fetchFavoriteCommunities();
  }

  void fetchFavoriteCommunities() {
    context.read<FavoriteCubit>().fetchFavoriteCommunities();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<FavoriteCubit>()
            .fetchFavoriteCommunities(forceRefresh: true);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
            if (_isFavoriteExpanded)
              BlocBuilder<FavoriteCubit, FavoriteStates>(
                  builder: (BuildContext context, FavoriteStates state) {
                if (state is FavoriteLoading) {
                  return const Center(child: LoadingState());
                } else if (state is FavoriteLoaded) {
                  if (state.communities.isEmpty) {
                    return NoDataWidget(
                      message:
                          "Looks like you haven't added any favorite communities yet... 👀",
                      height: 100.h,
                      width: 100.w,
                    );
                  }
                  return CommunityGrid(
                      communities: state.communities,
                      isFavoriteCommunity: true);
                } else if (state is FavoriteError) {
                  return Center(
                      child: ErrorStateWidget(
                          message: state.message,
                          onRetry: ()=> context.read<FavoriteCubit>().fetchFavoriteCommunities(forceRefresh: true)));
                }
                return const Center();
              }),
            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }
}
