import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user_infos/user.dart';
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

    final usrMgr = context.watch<CurrentUserManager>();

    Future<(String, String)> obtainLoginInfo() async {
      return ("", "");
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("User info"),
        ),
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                child: Column(children: <Flexible>[
                  Flexible(
                      flex: 4,
                      child: FutureBuilder(
                          future: obtainLoginInfo(),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                              case ConnectionState.active:
                                return const CircularProgressIndicator();
                              case ConnectionState.done:
                                if (snapshot.hasData) {
                                  final (uname, pwd) = snapshot.data!;

                                  return ListView(children: <Widget>[
                                    _UserInfoEditor(uname, pwd)
                                  ]);
                                }

                                return const Text(
                                    "Cannot obatin login info, try again later.");
                              default:
                                break;
                            }

                            return const SizedBox();
                          })),
                  Flexible(
                      child: ListView(shrinkWrap: true, children: <Widget>[
                    ElevatedButton(
                        onPressed: () {},
                        style: criticalBtnStyle,
                        child: const Text("Report losing member card",
                            style: TextStyle(color: Colors.white))),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                    ElevatedButton(
                        onPressed: () async {
                          if (await _promptLogout(context)) {
                            // Do logout here
                            usrMgr.flushUser();
                            Navigator.popUntil(context, (r) => r.isFirst);
                          }
                        },
                        style: criticalBtnStyle,
                        child: const Text("Logout",
                            style: TextStyle(color: Colors.white)))
                  ]))
                ]))));
  }
}

final class _UserInfoEditor extends StatefulWidget {
  final String uname, pwd;

  _UserInfoEditor(this.uname, this.pwd, {super.key});

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
          enabled: _editMode,
          decoration: InputDecoration(
              labelText: "Username",
              errorText: _invalidData ? "Invalid username" : null)),
      const Padding(padding: EdgeInsets.symmetric(vertical: 6)),
      buildPasswordField(context,
          enabled: _editMode,
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
