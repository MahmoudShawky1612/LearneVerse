import 'package:flutter/cupertino.dart';
import 'package:flutterwidgets/features/discover/presentation/widgets/build_section_header.dart';

import '../../../home/models/community_model.dart';
import '../../../home/presentation/widgets/community_grid.dart';

class BuildDefaultContent extends StatefulWidget {
  const BuildDefaultContent({super.key});

  @override
  State<BuildDefaultContent> createState() => _BuildDefaultContentState();
}

bool _isPendingExpanded = true;
bool _isFavoriteExpanded = true;
final List<Community> _communities = Community.generateDummyCommunities();

class _BuildDefaultContentState extends State<BuildDefaultContent> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            BuildSectionHeader(
              title: "Pending Communities",
              isExpanded: _isPendingExpanded,
              onTap: () {
                setState(() {
                  _isPendingExpanded = !_isPendingExpanded;
                });
              },
            ),
            if (_isPendingExpanded) CommunityGrid(communities: _communities),
            const SizedBox(height: 30),
            BuildSectionHeader(
              title: "Favorite Communities",
              isExpanded: _isFavoriteExpanded,
              onTap: () {
                setState(() {
                  _isFavoriteExpanded = !_isFavoriteExpanded;
                });
              },
            ),
            if (_isFavoriteExpanded) CommunityGrid(communities: _communities),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
