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

final class _UserInfoEditForm extends StatefulWidget {
  _UserInfoEditForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UserInfoEditFormState();
  }
}

final class _UserInfoEditFormState extends State<_UserInfoEditForm>
    with UserInfoEditFormStateMixin<_UserInfoEditForm> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
