import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/pages/auth/auth_or_page.dart';
import 'package:shop_flutter_app/pages/product/products_manager_page.dart';
import 'package:shop_flutter_app/pages/product/products_overview_page.dart';
import 'package:shop_flutter_app/providers.dart';
import 'package:shop_flutter_app/pages/cart/cart_page.dart';
import 'package:shop_flutter_app/pages/order/order_page.dart';
import 'package:shop_flutter_app/pages/product/product_detail_page.dart';
import 'package:shop_flutter_app/pages/product/product_form_page.dart';
import 'package:shop_flutter_app/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: Providers.getProviders(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'shop app flutter',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Lato',
        ),
        routes: {
          // Routes.auth: (_) => const AuthPage(),
          Routes.home: (_) => const AuthOrPage(ProductsOverviewPage()),
          Routes.productDetail: (_) => const AuthOrPage(ProductDetailPage()),
          Routes.cart: (_) => const AuthOrPage(CartPage()),
          Routes.order: (_) => const AuthOrPage(OrderPage()),
          Routes.products: (_) => const AuthOrPage(ProductsManager()),
          Routes.productForm: (_) => const AuthOrPage(ProductFormPage()),
        },
      ),
    );
  }
}
