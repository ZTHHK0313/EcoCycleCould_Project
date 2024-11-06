import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/user_infos/user.dart';
import 'pages/login.dart';
import 'pages/home.dart';

final class ContentInitializer extends StatelessWidget {
  const ContentInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CurrentUserManager>(
        create: (_) => CurrentUserManager(),
        builder: (context, _) {
          final usrMgr = context.watch<CurrentUserManager>();

          return usrMgr.hasCurrentUser ? const HomePage() : const LoginPage();
        });
  }
}
