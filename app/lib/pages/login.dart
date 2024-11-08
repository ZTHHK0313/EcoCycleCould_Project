import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user_infos/user.dart';
import '../themes/colours.dart';
import 'user_form_mixin.dart';
import 'home.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceMQSize = MediaQuery.of(context).size;
    final horizontalPadding = deviceMQSize.width * 0.0625;

    return Scaffold(
        backgroundColor: ecoGreen[500],
        body: SafeArea(
            child: Center(
                child: Card(
                    color: ecoGreen[100],
                    margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8, horizontal: horizontalPadding),
                        child: const _LoginControlUnit())))));
  }
}

class _LoginControlUnit extends StatefulWidget {
  const _LoginControlUnit();

  @override
  State<_LoginControlUnit> createState() {
    return _LoginControlUnitState();
  }
}

class _LoginControlUnitState extends State<_LoginControlUnit>
    with UserInfoEditFormStateMixin<_LoginControlUnit> {
  bool _loginFailed = false;

  Future<User?> _onLogin(String uname, String pwd) async {
    if (uname.isNotEmpty && pwd.isNotEmpty) {
      return User(1);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      buildUsernameField(
        context,
        decoration: InputDecoration(
            labelText: "Username",
            errorText: _loginFailed ? "Invalid username" : null),
      ),
      const Padding(padding: EdgeInsets.symmetric(vertical: 6)),
      buildPasswordField(context,
          decoration: InputDecoration(
              labelText: "Password",
              errorText: _loginFailed ? "Invalid password" : null)),
      const Divider(),
      Consumer<CurrentUserManager>(builder: (context, usrMgr, _) {
        return ElevatedButton(
          onPressed: () async {
            final unameVal = unameCtrl.text;
            final pwdVal = pwdCtrl.text;

            User? usrInfo = await _onLogin(unameVal, pwdVal);
            setState(() {
              _loginFailed = usrInfo == null;
            });

            if (usrInfo != null) {
              usrMgr.attachUser(usrInfo);
            }
          },
          child: const Text("Login"));
      })
    ]);
  }
}
