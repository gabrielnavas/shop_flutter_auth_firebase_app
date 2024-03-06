import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/components/app_drawer.dart';
import 'package:shop_flutter_app/components/center_message.dart';
import 'package:shop_flutter_app/components/circular_progress_message.dart';
import 'package:shop_flutter_app/components/order_widget.dart';
import 'package:shop_flutter_app/exceptions/http_exception.dart';
import 'package:shop_flutter_app/providers/order_list.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders(context);
  }

  @override
  Widget build(BuildContext context) {
    final OrderList orderList = Provider.of<OrderList>(context);

    Widget body = CircularProgressMessage(
      'Carregando pedidos. Aguarde!',
      () => () async => _loadOrders(context),
    );

    if (orderList.orderCount == 0) {
      body = CenterMessage(
        'Nenhum pedido foi feito ainda',
        () async => _loadOrders(context),
      );
    } else if (!_isLoading) {
      body = RefreshIndicator(
        onRefresh: () async => _loadOrders(context),
        child: ListView.builder(
          itemCount: orderList.orderCount,
          itemBuilder: (context, index) => OrderWidget(orderList.items[index]),
        ),
      );
    }

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text(
          'Meus pedidos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: body,
    );
  }

  void _loadOrders(BuildContext context) {
    Provider.of<OrderList>(context, listen: false)
        .loadOrders()
        .then((_) => setState(() => _isLoading = false))
        .catchError((ex) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ex is HttpException ? ex.message : 'Tente novamente mais tarde',
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }
}
