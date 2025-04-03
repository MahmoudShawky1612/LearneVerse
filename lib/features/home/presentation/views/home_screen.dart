import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/build_search_results.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/main_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../discover/presentation/widgets/vertical_users_list.dart';
import '../../../profile/presentation/widgets/vertical_community_list.dart';
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

  @override
  void initState() {
    super.initState();
    _foundCommunities = [];
    _foundUsers = [];
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _search(String query) {
    setState(() {
      _foundCommunities = Community.searchCommunities(query);
      _foundUsers = Author.searchUsers(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
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
            const NotificationPanel(),
            _foundCommunities.isEmpty && _foundUsers.isEmpty
                ? Container()
                : BuildSearchResults(
                    communities: _foundCommunities,
                    users: _foundUsers,
                  ),
          ],
        ),
      ),
    );
  }
}
