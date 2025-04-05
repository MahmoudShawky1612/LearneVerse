import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../discover/presentation/widgets/vertical_users_list.dart';
import '../../../profile/presentation/widgets/vertical_community_list.dart';

class BuildSearchResults extends StatelessWidget {
  final communities;
  final users;
  final owners;
  final VoidCallback? onClose;

  const BuildSearchResults({
    super.key, 
    required this.communities, 
    required this.users, 
    required this.owners,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Positioned(
        left: 0,
        right: 0,
        top: 250,
        child: Center(
          child: Container(
            width: 380,
            height: 500,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(22),
                  topLeft: Radius.circular(22),
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.1),
                    blurRadius: 12,
                    spreadRadius: 0,
                    offset: const Offset(0, 6),
                  ),
                ],
                color: theme.cardColor),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(22),
                      topLeft: Radius.circular(22),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Search Results',
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: colorScheme.onSurface.withOpacity(0.7),
                          size: 20,
                        ),
                        onPressed: onClose,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 30,
                          minHeight: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 80.0),
                      child: Column(
                        children: [
                          VerticalCommunityList(
                            communities: communities,
                          ),
                          VerticalUserList(users: users),
                          VerticalUserList(users: owners),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
