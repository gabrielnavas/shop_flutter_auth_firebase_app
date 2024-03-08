import 'package:flutter/material.dart';
import 'package:shop_flutter_app/models/cart_item.dart';
import 'package:shop_flutter_app/models/product.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmout {
    double total = 0.00;

    for (MapEntry<String, CartItem> entry in _items.entries) {
      CartItem cartItem = entry.value;
      double priceProduct = cartItem.productPrice * cartItem.quantity;
      total = total + priceProduct;
    }

    return total;
  }

  bool exist(Product product) {
    return _items.containsKey(product.id);
  }

  void remove(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void add(Product product) {
    _items.putIfAbsent(
      product.id,
      () => CartItem(
        id: product.id,
        quantity: 1,
        productId: product.id,
        productName: product.name,
        productPrice: product.price,
        imageUrl: product.imageUrl,
      ),
    );
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void incrementQuantity(String productId) {
    _items.update(
      productId,
      (existingProduct) => CartItem(
        id: existingProduct.id,
        quantity: existingProduct.quantity + 1,
        productId: existingProduct.id,
        productName: existingProduct.productName,
        productPrice: existingProduct.productPrice,
        imageUrl: existingProduct.imageUrl,
      ),
    );
    notifyListeners();
  }

  void decrementQuantity(String productId) {
    final cartItem = _items[productId];
    if (cartItem == null) {
      return;
    }
    if (cartItem.quantity - 1 == 0) {
      return;
    }
    _items.update(
      cartItem.productId,
      (existingProduct) => CartItem(
        id: existingProduct.id,
        quantity: existingProduct.quantity - 1,
        productId: existingProduct.id,
        productName: existingProduct.productName,
        productPrice: existingProduct.productPrice,
        imageUrl: existingProduct.imageUrl,
      ),
    );
    notifyListeners();
  }
}
