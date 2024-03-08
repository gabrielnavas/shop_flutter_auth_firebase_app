import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_flutter_app/constants/api.dart';
import 'package:shop_flutter_app/exceptions/http_exception.dart';
import 'package:shop_flutter_app/models/cart.dart';
import 'package:shop_flutter_app/models/order.dart';
import 'package:uuid/uuid.dart';

import 'package:http/http.dart' as http;

class OrderList with ChangeNotifier {
  String _url = '';
  final String _token;
  final String _userId;

  List<Order> _items = [];

  OrderList([this._token = '', this._userId = '', this._items = const []]) {
    _url = "$api/orders/$_userId";
  }

  List<Order> get items => [..._items];

  int get orderCount => _items.length;

  Future<void> addOrder(Cart cart) async {
    Order order = Order(
      id: const Uuid().v4(),
      total: cart.totalAmout,
      cartItems: cart.items.values.toList(),
      date: DateTime.now(),
      userId: _userId,
    );

    _items.insert(0, order);
    notifyListeners();

    final String orderJson = order.toJson();

    try {
      final resp = await http.post(
        Uri.parse(
          '$_url.json?auth=$_token',
        ),
        body: orderJson,
      );

      if (resp.statusCode >= 400) {
        items.remove(order);
        notifyListeners();
        throw HttpException(
          message:
              'Não foi possível concluir a operação. Tente novamente mais tarde.',
          status: 400,
        );
      }

      final body = jsonDecode(resp.body);

      String orderIdFirebase = body['name'] as String;
      order.id = orderIdFirebase;
    } catch (ex) {
      items.remove(order);
      notifyListeners();
      throw HttpException(
        message:
            'Não foi possível concluir a operação. Tente novamente mais tarde.',
        status: 400,
      );
    }
  }

  Future<void> loadOrders() async {
    _items.clear();

    try {
      final resp = await http.get(
        Uri.parse(
          '$_url.json?auth=$_token',
        ),
      );
      if (resp.statusCode >= 400) {
        throw HttpException(
          message:
              'Não foi possível carregar os pedidos. Tente novamente mais tarde.',
          status: 400,
        );
      }

      final dynamic body = jsonDecode(resp.body);
      if (body == null) {
        return;
      }

      body.forEach((orderId, orderData) {
        _items.add(Order.fromMap(orderId: orderId, orderData: orderData));
      });
    } on HttpException catch (_) {
      rethrow;
    } catch (ex) {
      throw HttpException(
        message:
            'Não foi possível carregar os pedidos. Tente novamente mais tarde.',
        status: 400,
      );
    }
  }
}
