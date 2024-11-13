import 'package:eco_cycle_cloud/controller/user.dart';
import 'package:flutter/material.dart';

mixin UserInfoEditFormStateMixin<T extends StatefulWidget> on State<T> {
  @protected
  late final TextEditingController unameCtrl, pwdCtrl;

  @override
  void initState() {
    super.initState();
    unameCtrl = TextEditingController();
    pwdCtrl = TextEditingController();
  }

  @override
  void dispose() {
    unameCtrl.dispose();
    pwdCtrl.dispose();
    super.dispose();
  }

  @protected
  UserLoginIdentity get loginIdentity => (uname: unameCtrl.text, pwd: pwdCtrl.text);

  @protected
  TextField buildUsernameField(BuildContext context,
      {bool enabled = true,
      InputDecoration decoration = const InputDecoration()}) {
    return TextField(
        controller: unameCtrl,
        autocorrect: false,
        enableSuggestions: false,
        decoration: decoration,
        enabled: enabled);
  }

  @protected
  TextField buildPasswordField(BuildContext context,
      {bool enabled = true,
      InputDecoration decoration = const InputDecoration()}) {
    return TextField(
        controller: pwdCtrl,
        autocorrect: false,
        enableSuggestions: false,
        obscureText: true,
        decoration: decoration,
        enabled: enabled);
  }
}
