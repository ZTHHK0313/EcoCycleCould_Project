import 'dart:convert';

import '../model/user_infos/user.dart';
import '../net/rest_client.dart';
import '../net/url.dart';

typedef UserLoginIdentity = ({String uname, String pwd});

Future<User?> verifyLogin(UserLoginIdentity identity) async {
  return switch (identity) {
    (uname: "Alice", pwd: "1234") => User(0),
    (uname: "Bob", pwd: "4321") => User(1),
    _ => null
  };
}

Future<UserLoginIdentity> queryLoginInfo(User usr) async {
  switch (usr.identifier) {
    case 0:
      return (uname: "Alice", pwd: "1234");
    case 1:
      return (uname: "Bob", pwd: "4321");
    default:
      throw Exception("Unknown user id: ${usr.identifier}");
  }
}

Future<bool> alterLoginIdentity(User usr, UserLoginIdentity newIdentity) async {
  if (newIdentity.uname.isEmpty || newIdentity.pwd.isEmpty) {
    return false;
  }
  
  return true;
}

Future<Map<String, dynamic>> getRawUserData(User usr) async {
  final RestClient c = RestClient();

  try {
    return await c
      .get(APIPath.userData)
      .then((resp) => jsonDecode(resp.body)["df"][usr.identifier]);
  } finally {
    c.close();
  }
}
