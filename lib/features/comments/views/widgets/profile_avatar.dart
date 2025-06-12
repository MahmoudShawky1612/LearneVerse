import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../utils/url_helper.dart';
import '../../data/models/comment_model.dart';

class ProfileAvatar extends StatelessWidget {
  final Comment comment;

  const ProfileAvatar({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/profile', extra: comment.author.id),
      child: CircleAvatar(
        radius: 14.r,
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        child: _getAvatarContent(comment, context),
      ),
    );
  }

  Widget _getAvatarContent(Comment comment, BuildContext context) {
    final profilePictureURL = comment.author.userProfile?.profilePictureURL;

    if (profilePictureURL != null && profilePictureURL.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: UrlHelper.transformUrl(profilePictureURL),
          width: 28.r,
          height: 28.r,
          fit: BoxFit.cover,
          errorWidget: (context, error, stackTrace) {
            return _getDefaultAvatar(context);
          },
          placeholder: (context, url) => SizedBox(
            width: 28.r,
            height: 28.r,
            child: const CupertinoActivityIndicator(),
          ),
        ),
      );
    } else {
      return _getDefaultAvatar(context);
    }
  }

  Widget _getDefaultAvatar(BuildContext context) {
    return Icon(
      Icons.person,
      size: 16.r,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
