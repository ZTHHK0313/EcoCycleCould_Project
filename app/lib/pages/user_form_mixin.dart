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
  TextField buildUsernameField(BuildContext context,
      {InputDecoration decoration = const InputDecoration()}) {
    return TextField(
        controller: unameCtrl,
        autocorrect: false,
        enableSuggestions: false,
        decoration: decoration);
  }

  @protected
  TextField buildPasswordField(BuildContext context,
      {InputDecoration decoration = const InputDecoration()}) {
    return TextField(
        controller: pwdCtrl,
        autocorrect: false,
        enableSuggestions: false,
        obscureText: true,
        decoration: decoration);
  }
}
