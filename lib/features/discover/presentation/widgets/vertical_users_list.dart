import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/discover/presentation/widgets/users_item.dart';

import '../../../profile/presentation/widgets/no_profile_widget.dart';

class VerticalUserList extends StatelessWidget {
  final users;

  const VerticalUserList({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return users.isEmpty ?   NoDataWidget(message: "No classes yet... 👀", width: 100.w, height: 100.h,):ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: users.length,
      padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 8.w),
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            UserItem(user: users[index]),
            const Divider(),
          ],
        );
      },
    );
  }
}
