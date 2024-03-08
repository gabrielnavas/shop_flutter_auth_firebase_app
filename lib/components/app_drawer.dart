import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/auth.dart';
import 'package:shop_flutter_app/routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text(
              'Bem vindo usuário!',
              textAlign: TextAlign.center,
            ),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Loja'),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(Routes.home),
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Pedidos'),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(Routes.order),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Gerenciar produtos'),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(Routes.products),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sair'),
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Até mais! :)'),
                  duration: Duration(seconds: 4),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
