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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        buildUsernameField(context),
        const Padding(padding: EdgeInsets.symmetric(vertical: 6)),
        buildPasswordField(context)
      ]
    );
  }
}
