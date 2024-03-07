import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shop_flutter_app/models/cart.dart';
import 'package:shop_flutter_app/providers/auth.dart';
import 'package:shop_flutter_app/providers/order_list.dart';
import 'package:shop_flutter_app/providers/product_list.dart';

class Providers {
  static List<SingleChildWidget> getProviders() {
    return [
      ChangeNotifierProvider(
        create: (_) => Auth(),
      ),
      ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList('', []),
          update: (context, auth, previousProductList) {
            return ProductList(
              auth.authData?.token ?? '',
              previousProductList?.items ?? [],
            );
          }),
      ChangeNotifierProvider(
        create: (_) => Cart(),
      ),
      ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList(''),
          update: (context, auth, previousOrderList) {
            return OrderList(
              auth.authData?.token ?? '',
            );
          }),
    ];
  }
}
