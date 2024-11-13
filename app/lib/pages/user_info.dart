import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/user.dart';
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
                      child: FutureBuilder<UserLoginIdentity>(
                          future: queryLoginInfo(usrMgr.current),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                              case ConnectionState.active:
                                return const CircularProgressIndicator();
                              case ConnectionState.done:
                                if (snapshot.hasData) {
                                  return ListView(children: <Widget>[
                                    _UserInfoEditor(
                                        usrMgr.current, snapshot.data!)
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
  final User currentUsr;
  final UserLoginIdentity origin;

  _UserInfoEditor(this.currentUsr, this.origin, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _UserInfoEditorState();
  }
}

final class _UserInfoEditorState extends State<_UserInfoEditor>
    with UserInfoEditFormStateMixin<_UserInfoEditor> {
  late bool _editMode, _invalidData;
  late UserLoginIdentity origin;

  @override
  void initState() {
    _editMode = _invalidData = false;
    super.initState();
    origin = widget.origin;
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
              if (_editMode && origin != loginIdentity) {
                bool isInvalid =
                    !await alterLoginIdentity(widget.currentUsr, loginIdentity);

                setState(() {
                  _invalidData = isInvalid;
                  if (!isInvalid) {
                    origin = loginIdentity;
                  }
                });

                if (isInvalid) {
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
