import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/utils/responsive_utils.dart';
import 'package:flutterwidgets/core/widgets/responsive_wrapper.dart';
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
    
    // Fixed button sizes for consistency
    const double buttonSize = 42;
    const double buttonSpacing = 12;
    
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            // Use responsive wrapper for different device layouts
            ResponsiveWrapper(
              mobile: _buildMobileLayout(),
              tablet: _buildTabletLayout(),
              desktop: _buildDesktopLayout(),
            ),

            Positioned(
              top: 140,
              left: 0,
              right: 0,
              child: CustomSearchBar(searchController, _search),
            ),
            
            Positioned(
              right: 30 + buttonSize + buttonSpacing,
              top: 15,
              child: Container(
                width: buttonSize,
                height: buttonSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: theme.colorScheme.surface.withOpacity(0.15),
                ),
                child: const Center(
                  child: ThemeToggleButton(
                    isCompact: true,
                    size: 18,
                  ),
                ),
              ),
            ),
            
            const NotificationPanel(),
            
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
        // No space between header and content
        Expanded(
          child: Container(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: MainContent(),
          ),
        ),
      ],
    );
  }
  
  Widget _buildTabletLayout() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.w(16)),
          child: const HomeHeader(),
        ),
        // No space between header and content
        Expanded(
          child: Container(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.symmetric(horizontal: context.w(16)),
            child: MainContent(),
          ),
        ),
      ],
    );
  }
  
  Widget _buildDesktopLayout() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.w(32)),
          child: const HomeHeader(),
        ),
        // No space between header and content
        Expanded(
          child: Container(
            margin: EdgeInsets.zero,
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                padding: EdgeInsets.symmetric(horizontal: context.w(32)),
                child: MainContent(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool _hasSearchResults() {
    return _isSearching && (_foundCommunities.isNotEmpty || _foundUsers.isNotEmpty || _foundOwners.isNotEmpty);
  }
}
