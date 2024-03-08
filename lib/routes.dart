import 'package:flutter/material.dart';
import 'package:shop_flutter_app/pages/auth/auth_or_page.dart';
import 'package:shop_flutter_app/pages/cart/cart_page.dart';
import 'package:shop_flutter_app/pages/order/order_page.dart';
import 'package:shop_flutter_app/pages/product/product_detail_page.dart';
import 'package:shop_flutter_app/pages/product/product_form_page.dart';
import 'package:shop_flutter_app/pages/product/products_manager_page.dart';
import 'package:shop_flutter_app/pages/product/products_overview_page.dart';

class Routes {
  // static String auth = '/';
  static String home = '/';
  static String productDetail = '/product-detail';
  static String cart = '/cart';
  static String order = '/order';
  static String products = '/products';
  static String productForm = '/products-form';

  static Map<String, Widget Function(BuildContext)> getRoutes() {
    return {
      // Routes.auth: (_) => const AuthPage(),
      Routes.home: (_) => const AuthOrPage(ProductsOverviewPage()),
      Routes.productDetail: (_) => const AuthOrPage(ProductDetailPage()),
      Routes.cart: (_) => const AuthOrPage(CartPage()),
      Routes.order: (_) => const AuthOrPage(OrderPage()),
      Routes.products: (_) => const AuthOrPage(ProductsManager()),
      Routes.productForm: (_) => const AuthOrPage(ProductFormPage()),
    };
  }
}
