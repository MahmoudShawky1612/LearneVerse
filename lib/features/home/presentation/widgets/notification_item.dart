import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

    return Container(
      decoration: BoxDecoration(
        color: isNew ? Colors.blue.withOpacity(0.05) : Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(notification['image']),
                  radius: 24,
                ),
                if (isNew)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 12),

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
                            fontSize: 14,
                            fontWeight:
                                isNew ? FontWeight.w600 : FontWeight.w500,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        notification['timeAgo'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 3),

                  Text(
                    notification['detailed'],
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
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
                size: 20,
                color: Colors.grey.shade400,
              ),
              onPressed: () {},
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 30,
                minHeight: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
