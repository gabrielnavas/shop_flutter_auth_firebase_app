import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/components/center_message.dart';
import 'package:shop_flutter_app/pages/auth/auth_page.dart';
import 'package:shop_flutter_app/providers/auth.dart';

class AuthOrPage extends StatelessWidget {
  final Widget page;
  const AuthOrPage(this.page, {super.key});

  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context);

    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CenterMessage('Logando...', () => null);
        }
        if (!auth.isAuth()) {
          return const AuthPage();
        }
        return page;
      },
    );
  }
}
