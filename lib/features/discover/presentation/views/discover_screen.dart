import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/community_grid.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/search_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

bool isPendingExpanded = true;
bool isFavoriteExpanded = true;

class _DiscoverScreenState extends State<DiscoverScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Discover communities, people and more....",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 50),
              const CustomSearchBar(),
              const SizedBox(height: 50),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 100),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 15.0),
                              child: Text(
                                "Pending communities",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    isPendingExpanded = !isPendingExpanded;
                                  });
                                },
                                icon: const Icon(
                                  Icons.arrow_drop_down_outlined,
                                  size: 30,
                                )),
                          ],
                        ),
                        const SizedBox(height: 20),
                        isPendingExpanded ? const CommunityGrid() : Container(),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 15.0),
                              child: Text(
                                "Favorite communities",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    isFavoriteExpanded = !isFavoriteExpanded;
                                  });
                                },
                                icon: const Icon(
                                  Icons.arrow_drop_down_outlined,
                                  size: 30,
                                )),
                          ],
                        ),
                        const SizedBox(height: 20),
                        isFavoriteExpanded ? const CommunityGrid() : Container(),





                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 15.0),
                              child: Text(
                                "Favorite communities",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    isFavoriteExpanded = !isFavoriteExpanded;
                                  });
                                },
                                icon: const Icon(
                                  Icons.arrow_drop_down_outlined,
                                  size: 30,
                                )),
                          ],
                        ),
                        const SizedBox(height: 20),
                        isFavoriteExpanded ? const CommunityGrid() : Container(),Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 15.0),
                              child: Text(
                                "Favorite communities",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    isFavoriteExpanded = !isFavoriteExpanded;
                                  });
                                },
                                icon: const Icon(
                                  Icons.arrow_drop_down_outlined,
                                  size: 30,
                                )),
                          ],
                        ),
                        const SizedBox(height: 20),
                        isFavoriteExpanded ? const CommunityGrid() : Container(),Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 15.0),
                              child: Text(
                                "Favorite communities",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    isFavoriteExpanded = !isFavoriteExpanded;
                                  });
                                },
                                icon: const Icon(
                                  Icons.arrow_drop_down_outlined,
                                  size: 30,
                                )),
                          ],
                        ),
                        const SizedBox(height: 20),
                        isFavoriteExpanded ? const CommunityGrid() : Container(),Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 15.0),
                              child: Text(
                                "Favorite communities",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    isFavoriteExpanded = !isFavoriteExpanded;
                                  });
                                },
                                icon: const Icon(
                                  Icons.arrow_drop_down_outlined,
                                  size: 30,
                                )),
                          ],
                        ),
                        const SizedBox(height: 20),
                        isFavoriteExpanded ? const CommunityGrid() : Container(),Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 15.0),
                              child: Text(
                                "Favorite communities",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    isFavoriteExpanded = !isFavoriteExpanded;
                                  });
                                },
                                icon: const Icon(
                                  Icons.arrow_drop_down_outlined,
                                  size: 30,
                                )),
                          ],
                        ),
                        const SizedBox(height: 20),
                        isFavoriteExpanded ? const CommunityGrid() : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
