import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/widgets/theme_toggle_button.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/build_search_results.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/main_content.dart';

import '../../../community/models/owner_model.dart';
import '../../models/author_model.dart';
import '../../models/community_model.dart';
import '../widgets/home_header.dart';
import '../widgets/notification_panel.dart';
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
    // Using theme instead of direct color references
    final theme = Theme.of(context);
    
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            const HomeHeader(),
            MainContent(),
            Positioned(
                top: 170,
                left: 0,
                right: 0,
                child: CustomSearchBar(searchController, _search)),
            // Toggle button for theme positioned to left of notifications
            const Positioned(
              right: 90, // Position to the left of notification icon
              top: 15,
              child: ThemeToggleButton(
                isCompact: true,
                size: 18,
              ),
            ),
            const NotificationPanel(),
            if (_hasSearchResults())
              GestureDetector(
                onTap: _clearSearch,
                child: Container(
                  color: Colors.black.withOpacity(0.4),
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

  bool _hasSearchResults() {
    return _isSearching && (_foundCommunities.isNotEmpty || _foundUsers.isNotEmpty || _foundOwners.isNotEmpty);
  }
}
