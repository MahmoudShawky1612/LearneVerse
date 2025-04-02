import 'package:flutter/cupertino.dart';
import 'package:flutterwidgets/features/home/models/home_model.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/build_posts.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/community_grid.dart';

class MainContent extends StatelessWidget {
   MainContent({super.key});
  final List<Post> posts = Post.generateDummyPosts(15);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 200.0, left: 20.0, right: 20.0),
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 50, bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  'Joined Communities',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const CommunityGrid(),
              const SizedBox(height: 20),
              BuildPosts(scrollPhysics: const NeverScrollableScrollPhysics(), posts: posts,),
            ],
          ),
        ),
      ),
    );
  }
}
