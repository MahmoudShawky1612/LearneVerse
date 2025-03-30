import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'notification_item.dart';

class NotificationPanel extends StatefulWidget {
  const NotificationPanel({super.key});

  @override
  State<NotificationPanel> createState() => _NotificationPanelState();
}

class _NotificationPanelState extends State<NotificationPanel>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleNotifications() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> avatars = [
      'assets/images/avatar1.jpg',
      'assets/images/avatar2.jpg',
      'assets/images/avatar3.jpg',
      'assets/images/avatar4.jpg',
      'assets/images/avatar5.jpg',
      'assets/images/avatar6.jpg',
    ];

    final List<String> title = [
      "Ahmed upvoted your comment",
      "Maged downvoted your comment",
      "Aslam upvoted your post",
      "Ali upvoted your post",
      "Hassan replied to your comment",
    ];

    final List<String> timeAgo = [
      "Just now",
      "2m ago",
      "10m ago",
      "1h ago",
      "3h ago",
    ];

    final List<Map<String, dynamic>> notifications = List.generate(
      15,
      (index) => {
        "title": title[index % title.length],
        "detailed": "Go and see this new activity",
        "image": avatars[index % avatars.length],
        "timeAgo": timeAgo[index % timeAgo.length],
        "isNew": index < 3, // First three are new
      },
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          right: 30,
          top: 15,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isExpanded
                      ? Colors.white
                      : Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.bell,
                    size: 18,
                    color: isExpanded ? Colors.blue : Colors.white,
                  ),
                  onPressed: _toggleNotifications,
                  tooltip: 'Notifications',
                  padding: EdgeInsets.zero,
                ),
              ),
              Positioned(
                top: 6,
                right: 8,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Positioned(
              right: 30,
              top: 65,
              child: AnimatedOpacity(
                opacity: isExpanded ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Visibility(
                  visible: isExpanded,
                  child: Container(
                    width: 380,
                    height: 500,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 20,
                          spreadRadius: 0,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Notifications',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Mark all as read',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: notifications.length,
                            itemBuilder: (context, index) {
                              return NotificationItem(
                                notification: notifications[index],
                                isLast: index == notifications.length - 1,
                              );
                            },
                          ),
                        ),
                        const Divider(height: 1),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.blue,
                              ),
                              child: const Text(
                                'View all notifications',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
