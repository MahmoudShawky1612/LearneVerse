import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/discover/views/widgets/build_default_content.dart';
import 'package:flutterwidgets/features/discover/views/widgets/build_header.dart';
import 'package:flutterwidgets/features/discover/views/widgets/build_search_results.dart';
import 'package:flutterwidgets/features/discover/views/widgets/build_filters_list.dart';
import 'package:flutterwidgets/utils/loading_state.dart';

import '../../home/views/widgets/search_bar.dart';
import '../logic/cubit/favorite_communities_cubit.dart';
import '../logic/cubit/search_cubit.dart';
import '../logic/cubit/search_states.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _selectedFilters = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<SearchCubit>().search(query: '', tagNames: []);
  }

  void _toggleFilter(String filter) {
    setState(() {
      if (_selectedFilters.contains(filter)) {
        _selectedFilters.remove(filter);
      } else {
        _selectedFilters.add(filter);
      }
      if (_searchController.text.isNotEmpty) {
        context.read<SearchCubit>().search(
              query: _searchController.text,
              tagNames: _selectedFilters.isNotEmpty ? _selectedFilters : null,
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        extendBody: true,
        body: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 40.w, 20.w, 80.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BuildHeader(),
              SizedBox(height: 24.h),
              CustomSearchBar(
                searchController: _searchController,
                searchFunction: (query) => context.read<SearchCubit>().search(
                      query: query,
                      tagNames:
                          _selectedFilters.isNotEmpty ? _selectedFilters : null,
                    ),
              ),
              SizedBox(height: 24.h),
              BuildFiltersList(
                selectedFilters: _selectedFilters,
                onFilterToggle: _toggleFilter,
              ),
              SizedBox(height: 24.h),
              Expanded(
                child: BlocBuilder<SearchCubit, SearchStates>(
                  builder: (context, state) {
                    if (state is SearchLoading) {
                      return const Center(child: LoadingState());
                    } else if (state is SearchLoaded) {
                      if (state.communities.isEmpty && state.users.isEmpty) {
                        return const BuildDefaultContent();
                      }
                      return BuildSearchResults(
                        foundCommunities: state.communities,
                        foundUsers: state.users,
                      );
                    } else {
                      return const BuildDefaultContent();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
