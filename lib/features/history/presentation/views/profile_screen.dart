import 'package:flutter/material.dart';
import 'package:flutterwidgets/features/history/models/user_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/contribution_header.dart';
import '../widgets/user_contribution_comments.dart';
import '../widgets/user_contribution_posts.dart';
import '../widgets/user_joined_communities.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Colors.blue, Colors.pink]),
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  const Positioned(
                    left: 25,
                    top: 20,
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/avatar.jpg'),
                      radius: 35,
                    ),
                  ),
                  const Positioned(
                    left: 25,
                    top: 100,
                    child: SizedBox(
                      width: 200,
                      child: Text(
                        "Dodje Shawky",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 25,
                    top: 150,
                    child: SizedBox(
                      width: 200,
                      child: Text(
                        "كَلَّا إِنَّ مَعِيَ رَبِّي سَيَهْدِينِ",
                        style: TextStyle(
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                            color: Colors.white),
                        maxLines: 2,
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 25,
                    top: 190,
                    child: FaIcon(
                      FontAwesomeIcons.clock,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                  const Positioned(
                      left: 45,
                      top: 187,
                      child: Text("Active 1 hour ago",
                          style: TextStyle(color: Colors.white))),
                  const Positioned(
                    left: 25,
                    top: 220,
                    child: FaIcon(
                      FontAwesomeIcons.calendar,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                  const Positioned(
                      left: 45,
                      top: 217,
                      child: Text("Created At Mar 31, 2025",
                          style: TextStyle(color: Colors.white))),
                ],
              ),
              const ContributionHeader(),
              const SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(onPressed: (){setState(() {
                    selectedIndex = 0;
                  });}, child: const Text("Contributions", style: TextStyle(color: Colors.blue, fontSize: 25),)),
                  const Divider(),
                  TextButton(onPressed: (){setState(() {
                    selectedIndex = 1;
                  });}, child: const Text("Communities", style: TextStyle(color: Colors.blue, fontSize: 25),)),
                ],
              ),
              const Divider(),
              selectedIndex == 0 ? Expanded(child: SingleChildScrollView(child: Column(children: [UserComments(),UserPosts()],))) :  Expanded(child: VerticalCommunityList())
            ],
          ),
        ),
      ),
    );
  }
}


