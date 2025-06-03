import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                borderRadius:  BorderRadius.only(
                  topRight: Radius.circular(22.r),
                  topLeft: Radius.circular(22.r),
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
                  padding:  EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius:  BorderRadius.only(
                      topRight: Radius.circular(22.r),
                      topLeft: Radius.circular(22.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Search Results',
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: colorScheme.onSurface.withOpacity(0.7),
                          size: 20.w,
                        ),
                        onPressed: onClose,
                        padding: EdgeInsets.zero,
                        constraints:  BoxConstraints(
                          minWidth: 30.w,
                          minHeight: 30.h,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:  EdgeInsets.only(bottom: 80.h),
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
