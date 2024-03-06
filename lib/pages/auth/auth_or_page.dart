import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/pages/auth/auth_page.dart';
import 'package:shop_flutter_app/providers/auth.dart';

class AuthOrPage extends StatelessWidget {
  final Widget page;
  const AuthOrPage(this.page, {super.key});

  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context);

    if (auth.isAuth()) {
      return page;
    }

    return const AuthPage();
  }
}
