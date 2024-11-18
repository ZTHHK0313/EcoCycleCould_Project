import 'dart:convert';

import '../model/user_infos/user.dart';
import '../net/rest_client.dart';
import '../net/url.dart';

typedef UserLoginIdentity = ({String uname, String pwd});

List<UserLoginIdentity> _dummyLoginInfo = [
  (uname: "Alice", pwd: "1234"),
  (uname: "Bob", pwd: "4321")
];

Future<User?> verifyLogin(UserLoginIdentity identity) async {
  final int uidx = _dummyLoginInfo.indexWhere((info) => info == identity);

  return uidx >= 0 ? User(uidx) : null;
}

Future<UserLoginIdentity> queryLoginInfo(User usr) async {
  return _dummyLoginInfo[usr.identifier];
}

Future<bool> alterLoginIdentity(User usr, UserLoginIdentity newIdentity) async {
  if (newIdentity.uname.isEmpty || newIdentity.pwd.isEmpty) {
    return false;
  }

  _dummyLoginInfo[usr.identifier] = newIdentity;
  
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
