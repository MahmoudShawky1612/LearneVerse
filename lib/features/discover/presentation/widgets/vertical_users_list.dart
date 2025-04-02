import 'package:flutter/cupertino.dart';
import 'package:flutterwidgets/features/discover/presentation/widgets/users_item.dart';

import '../../../home/models/author_model.dart';

class VerticalUserList extends StatelessWidget {
  final List<Author> users;

  const VerticalUserList({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: users.length,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      itemBuilder: (BuildContext context, int index) {
        return UserItem(user: users[index]);
      },
    );
  }
}
