import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/home/data/models/community_model.dart';
import 'package:flutterwidgets/utils/url_helper.dart';

class CommunitySliverAppBar extends StatelessWidget {
  final Community community;

  const CommunitySliverAppBar({super.key, required this.community});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SliverAppBar(
      expandedHeight: 400.0.h,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.network(
              UrlHelper.transformUrl(community.coverImgURL),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade300,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.groups,
                    size: 48.r,
                    color: Colors.grey,
                  ),
                );
              },
            ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
        title: Text(
          community.name,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
    );
  }
}