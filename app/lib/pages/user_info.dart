import 'package:flutter/material.dart';

import 'user_form_mixin.dart';

final class UserInfoPage extends StatelessWidget {
  const UserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
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
