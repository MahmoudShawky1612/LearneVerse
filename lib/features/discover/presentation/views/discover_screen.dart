import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/features/community/models/owner_model.dart';
import 'package:flutterwidgets/features/discover/presentation/widgets/build_default_content.dart';
import 'package:flutterwidgets/features/discover/presentation/widgets/build_header.dart';
import 'package:flutterwidgets/features/discover/presentation/widgets/build_search_results.dart';
import 'package:flutterwidgets/features/home/models/author_model.dart';
import 'package:flutterwidgets/features/home/models/community_model.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/community_grid.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/search_bar.dart';
import '../../../profile/presentation/widgets/vertical_community_list.dart';
import '../widgets/build_filters_list.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  // Controllers
  final TextEditingController _searchController = TextEditingController();

  List<Community> _foundCommunities = [];
  List<Author> _foundUsers = [];
  List<String> _selectedFilters = [];
  List<Owner> _foundOwners = [];

  @override
  void initState() {
    super.initState();
    _foundCommunities = [];
    _foundUsers = [];
    _foundOwners=[];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search(String query) {
    setState(() {
      if (_selectedFilters.isNotEmpty) {
        _foundCommunities = Community.searchWithFilters(_selectedFilters, query);
      } else {
        _foundCommunities = Community.searchCommunities(query);
      }
      _foundUsers = Author.searchUsers(query);
      _foundOwners = Owner.searchOwners(query);
    });
  }


  void _toggleFilter(String filter) {
    setState(() {
      if (_selectedFilters.contains(filter)) {
        _selectedFilters.remove(filter);
      } else {
        _selectedFilters.add(filter);
      }
      if (_searchController.text.isNotEmpty) {
        _search(_searchController.text);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        extendBody: true,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BuildHeader(),
              const SizedBox(height: 24),
              CustomSearchBar(_searchController, _search),
              const SizedBox(height: 24),
              BuildFiltersList(
                selectedFilters: _selectedFilters,
                onFilterToggle: _toggleFilter,
              ),
              const SizedBox(height: 24),
              _isSearchActive()
                  ? Expanded(
                child: BuildSearchResults(
                  foundCommunities: _foundCommunities,
                  foundUsers: _foundUsers,
                  foundOwners: _foundOwners
                ),
              )
                  : const BuildDefaultContent(),
            ],
          ),
        ),
      ),
    );
  }

  bool _isSearchActive() {
    return _foundCommunities.isNotEmpty || _foundUsers.isNotEmpty || _foundOwners.isNotEmpty;
  }
}