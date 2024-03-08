import 'dart:convert';

import 'package:uuid/uuid.dart';

class CartItem {
  final String id;
  final String productId;
  final String productName;
  final int quantity;
  final double productPrice;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.productPrice,
    required this.imageUrl,
  });

  static CartItem create(
    String productId,
    String productName,
    int quantity,
    double productPrice,
    String imageUrl,
  ) {
    return CartItem(
      id: const Uuid().v4(),
      productId: productId,
      productName: productName,
      quantity: quantity,
      productPrice: productPrice,
      imageUrl: imageUrl,
    );
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  Map<String, Object> toMap() {
    return {
      "id": id,
      "productId": productId,
      "productName": productName,
      "quantity": quantity,
      "productPrice": productPrice,
      "imageUrl": imageUrl,
    };
  }

  static CartItem fromMap(Map<String, dynamic> cartItemMap) {
    return CartItem(
      id: cartItemMap["id"],
      productId: cartItemMap["productId"] as String,
      productName: cartItemMap["productName"] as String,
      quantity: cartItemMap["quantity"] as int,
      productPrice: cartItemMap["productPrice"] as double,
      imageUrl: cartItemMap["imageUrl"] as String,
    );
  }
}
