import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/discover/presentation/widgets/users_item.dart';

class VerticalUserList extends StatelessWidget {
  final users;

  const VerticalUserList({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
