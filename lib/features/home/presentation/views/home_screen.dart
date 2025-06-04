import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/core/widgets/theme_toggle_button.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/build_search_results.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/main_content.dart';
import '../../../community/models/owner_model.dart';
import '../../models/author_model.dart';
import '../../models/community_model.dart';
import '../widgets/home_header.dart';
import '../widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  List<Community> _foundCommunities = [];
  List<Author> _foundUsers = [];
  List<Owner> _foundOwners = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _foundCommunities = [];
    _foundUsers = [];
    _foundOwners = [];
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _search(String query) {
    if (query.isEmpty) {
      setState(() {
        _foundCommunities = [];
        _foundUsers = [];
        _foundOwners = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _foundCommunities = Community.searchCommunities(query);
      _foundUsers = Author.searchUsers(query);
      _foundOwners = Owner.searchOwners(query);
    });
  }

  void _clearSearch() {
    setState(() {
      searchController.clear();
      _foundCommunities = [];
      _foundUsers = [];
      _foundOwners = [];
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double buttonSize = 30.h;

    Widget layout;

    layout = _buildMobileLayout();

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            layout,
            Positioned(
              top: 120.h,
              left: 0,
              right: 0,
              child: CustomSearchBar(
                  searchController: searchController, searchFunction: _search),
            ),
            
            Positioned(
              right: buttonSize,
              top: 10.h,
              child: Container(
                width: buttonSize,
                height: buttonSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: theme.colorScheme.surface.withOpacity(0.15),
                ),
                child: Center(
                  child: ThemeToggleButton(
                    isCompact: true,
                    size: 15.w,
                  ),
                ),
              ),
            ),
            if (_hasSearchResults())
              GestureDetector(
                onTap: _clearSearch,
                child: Container(
                  color: theme.shadowColor.withOpacity(0.4),
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            if (_hasSearchResults())
              BuildSearchResults(
                communities: _foundCommunities,
                users: _foundUsers,
                owners: _foundOwners,
                onClose: _clearSearch,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        const HomeHeader(),
        Expanded(
          child: Container(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: const MainContent(),
          ),
        ),
      ],
    );
  }

  bool _hasSearchResults() {
    return _isSearching &&
        (_foundCommunities.isNotEmpty ||
            _foundUsers.isNotEmpty ||
            _foundOwners.isNotEmpty);
  }
}
