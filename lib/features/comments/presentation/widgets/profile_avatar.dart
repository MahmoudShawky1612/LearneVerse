import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';
import '../../../../utils/url_helper.dart';
import '../../data/models/comment_model.dart';

class ProfileAvatar extends StatelessWidget {
  final Comment comment;

  const ProfileAvatar({Key? key, required this.comment}) : super(key: key);

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
        child: Image.network(
          UrlHelper.transformUrl(profilePictureURL),
          width: 28.r,
          height: 28.r,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _getDefaultAvatar(context);
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              width: 28.r,
              height: 28.r,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            );
          },
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