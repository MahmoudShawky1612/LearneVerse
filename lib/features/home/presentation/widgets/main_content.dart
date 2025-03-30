import 'package:flutter/cupertino.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/build_posts.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/community_grid.dart';

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 250.0, left: 20.0, right: 20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Communities',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            CommunityGrid(),
            SizedBox(height: 20),
            Text(
              'Posts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            BuildPosts(),
          ],
        ),
      ),
    );
  }
}
