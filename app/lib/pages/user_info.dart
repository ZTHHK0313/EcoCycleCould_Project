import 'package:flutter/material.dart';

import '../themes/states.dart';
import 'user_form_mixin.dart';

final class UserInfoPage extends StatelessWidget {
  const UserInfoPage({super.key});

  Future<bool> _promptLogout(BuildContext context) async {
    return await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: const Text("Logout"),
                  content: const Text("Do you want to logout?"),
                  actions: <TextButton>[
                    TextButton(
                        onPressed: () {
                          Navigator.pop<bool>(context, true);
                        },
                        child: Text("Yes",
                            style: TextStyle(color: Colors.red[800]!))),
                    TextButton(
                        onPressed: () {
                          Navigator.pop<bool>(context, false);
                        },
                        child: const Text("No"))
                  ]);
            }) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle criticalBtnStyle = ButtonStyle(
        textStyle: ConstantWidgetStateProperties<TextStyle>.all(
            const TextStyle(color: Colors.white)),
        backgroundColor: ConstantWidgetStateProperties<Color>(Colors.red[800],
            selecting: Colors.red[900], useDefaultIfAbsent: true));

    return Scaffold(
        body: SafeArea(
            child: Column(children: <Flexible>[
      Flexible(flex: 4, child: ListView(children: <Widget>[_UserInfoEditor()])),
      Flexible(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            ElevatedButton(
                onPressed: () {},
                style: criticalBtnStyle,
                child: const Text("Report losing member card")),
            const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
            ElevatedButton(
                onPressed: () async {
                  if (await _promptLogout(context)) {
                    // Do logout here
                  }
                },
                style: criticalBtnStyle,
                child: const Text("Logout"))
          ]))
    ])));
  }
}

final class _UserInfoEditor extends StatefulWidget {
  _UserInfoEditor({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UserInfoEditorState();
  }
}

final class _UserInfoEditorState extends State<_UserInfoEditor>
    with UserInfoEditFormStateMixin<_UserInfoEditor> {
  late bool _editMode, _invalidData;

  Future<bool> _submitAlternation() async {
    return true;
  }

  Future<bool> _verifyInput() async {
    if (unameCtrl.text.isEmpty || pwdCtrl.text.isEmpty) {
      return false;
    }

    // Leave this place for verify with server side.

    return true;
  }

  @override
  void initState() {
    _editMode = _invalidData = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      buildUsernameField(context,
          decoration: InputDecoration(
              labelText: "Username",
              errorText: _invalidData ? "Invalid username" : null)),
      const Padding(padding: EdgeInsets.symmetric(vertical: 6)),
      buildPasswordField(context,
          decoration: InputDecoration(
              labelText: "Password",
              errorText: _invalidData ? "Invalid password" : null)),
      const Padding(padding: EdgeInsets.symmetric(vertical: 6)),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: <ElevatedButton>[
        ElevatedButton(
            onPressed: () async {
              if (_editMode) {
                bool isInvalidInput = !await _verifyInput();

                setState(() {
                  _invalidData = isInvalidInput;
                });

                if (isInvalidInput) {
                  return;
                }
              }

              setState(() {
                _editMode = !_editMode;
              });
            },
            child: Text(_editMode ? "Submit" : "Edit"))
      ])
    ]);
  }
}
