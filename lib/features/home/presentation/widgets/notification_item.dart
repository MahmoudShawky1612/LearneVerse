import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_utils.dart';

class NotificationItem extends StatelessWidget {
  final Map<String, dynamic> notification;
  final bool isLast;

  const NotificationItem({
    super.key,
    required this.notification,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isNew = notification['isNew'] ?? false;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Use screen width for responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final double avatarSize = screenWidth > 600 ? 24.0 : 20.0;
    final double horizontalPadding = screenWidth > 600 ? 20.0 : 12.0;
    final double verticalPadding = screenWidth > 600 ? 10.0 : 8.0;
    final double horizontalSpacing = screenWidth > 600 ? 12.0 : 8.0;
    final double verticalSpacing = screenWidth > 600 ? 3.0 : 2.0;

    return Container(
      decoration: BoxDecoration(
        color: isNew 
            ? colorScheme.primary.withOpacity(0.08) 
            : Colors.transparent,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding, 
          horizontal: horizontalPadding
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(notification['image']),
                  radius: avatarSize,
                ),
                if (isNew)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.scaffoldBackgroundColor, 
                          width: 1.5
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(width: horizontalSpacing),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First row with title and timestamp
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification['title'],
                          style: TextStyle(
                            fontSize: screenWidth > 600 ? 14.0 : 13.0,
                            fontWeight:
                                isNew ? FontWeight.w600 : FontWeight.w500,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: horizontalSpacing),
                      Text(
                        notification['timeAgo'],
                        style: TextStyle(
                          fontSize: screenWidth > 600 ? 12.0 : 11.0,
                          color: colorScheme.onSurface.withOpacity(0.6),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: verticalSpacing),

                  Text(
                    notification['detailed'],
                    style: TextStyle(
                      fontSize: screenWidth > 600 ? 13.0 : 12.0,
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            IconButton(
              icon: Icon(
                Icons.chevron_right,
                size: screenWidth > 600 ? 20.0 : 18.0,
                color: colorScheme.onSurface.withOpacity(0.4),
              ),
              onPressed: () {},
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(
                minWidth: screenWidth > 600 ? 30.0 : 25.0,
                minHeight: screenWidth > 600 ? 30.0 : 25.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
