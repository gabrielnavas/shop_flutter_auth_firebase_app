import 'package:flutter/material.dart';
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
        ],
      ),
    );
  }
}
