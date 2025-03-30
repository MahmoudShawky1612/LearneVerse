import 'package:flutter/material.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/main_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/home_header.dart';
import '../widgets/notification_panel.dart';
import '../widgets/search_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            HomeHeader(),
            CustomSearchBar(),
            MainContent(),
            NotificationPanel(),
          ],
        ),
      ),
    );
  }
}
