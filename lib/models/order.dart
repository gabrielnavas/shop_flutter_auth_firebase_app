import 'dart:convert';

import 'package:shop_flutter_app/models/cart_item.dart';

class Order {
  String id;
  final List<CartItem> cartItems;
  final DateTime date;
  final double total;
  String userId;

  Order(
      {required this.id,
      required this.total,
      required this.cartItems,
      required this.date,
      required this.userId});

  Map<String, Object> toMap() {
    final cartItemsListJson =
        cartItems.map((product) => product.toMap()).toList();
    final String cartItemsJson = jsonEncode(cartItemsListJson);

    return {
      "id": id,
      "total": total,
      "cartItems": cartItemsJson,
      "date": date.toIso8601String(),
      "userId": userId,
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
      date: DateTime.parse(orderData["date"]),
      userId: orderData["userId"] as String,
    );
  }
}
