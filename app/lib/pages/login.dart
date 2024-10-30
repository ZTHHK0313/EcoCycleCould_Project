import 'package:flutter/material.dart';

import '../themes/colours.dart';
import 'user_form_mixin.dart';

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
      ElevatedButton(
          onPressed: () {
            final unameVal = unameCtrl.text;
            final pwdVal = pwdCtrl.text;

            bool isInvalid = unameVal.isEmpty || pwdVal.isEmpty;
            setState(() {
              _loginFailed = isInvalid;
            });
          },
          child: const Text("Login"))
    ]);
  }
}
