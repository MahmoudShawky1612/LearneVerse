import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import '../../../home/presentation/widgets/build_posts.dart';
import '../../models/user_model.dart';

class UserPosts extends StatelessWidget {
  List<UserPost> userPosts = UserPost.generateDummyUserPosts(15);
  @override
  Widget build(BuildContext context) {
    return  BuildPosts(shrinkWrap: true, scrollPhysics: const BouncingScrollPhysics(), posts: userPosts,);
  }
}




