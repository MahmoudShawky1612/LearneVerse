import 'package:flutterwidgets/features/community/data/models/community_members_model.dart';
import 'package:flutterwidgets/utils/jwt_helper.dart';
import 'package:flutterwidgets/utils/token_storage.dart';

Future<bool> doesExistInCommunity(
    {required List<CommunityMember> communityMembers}) async {
  final token = await TokenStorage.getToken();
  final id = getUserIdFromToken(token!);
  print(id);
  return communityMembers.any((member) => member.id == id);
}
