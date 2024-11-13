import '../model/user_infos/user.dart';

typedef UserLoginIdentity = ({String uname, String pwd});

Future<User?> verifyLogin(UserLoginIdentity identity) async {
  return null;
}

Future<UserLoginIdentity> queryLoginInfo(User usr) async {
  return (uname: "", pwd: "");
}

Future<bool> alterLoginIdentity(User usr, UserLoginIdentity newIdentity) async {
  if (newIdentity.uname.isEmpty || newIdentity.pwd.isEmpty) {
    return false;
  }
  
  return true;
}
