import 'dart:convert';

import 'package:shop_flutter_app/models/cart_item.dart';

class Order {
  String id;
  final double total;
  final List<CartItem> cartItems;
  final DateTime date;

  Order({
    required this.id,
    required this.total,
    required this.cartItems,
    required this.date,
  });

  Map<String, Object> toMap() {
    final cartItemsListJson =
        cartItems.map((product) => product.toMap()).toList();
    final String cartItemsJson = jsonEncode(cartItemsListJson);

    return {
      "id": id,
      "total": total,
      "cartItems": cartItemsJson,
      "date": date.toIso8601String(),
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  static Order fromMap({
    String? orderId,
    required Map<String, dynamic> orderData,
  }) {
    final List<dynamic> cartItemsList = orderData["cartItems"] is String
        ? jsonDecode(orderData["cartItems"])
        : orderData["cartItems"];

    final List<CartItem> cartItems = [];
    for (var element in cartItemsList) {
      cartItems.add(CartItem.fromMap(element));
    }

    return Order(
        id: orderId ?? orderData["id"],
        total: orderData["total"] as double,
        cartItems: cartItems,
        date: DateTime.parse(orderData["date"]));
  }
}
