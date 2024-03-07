import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_flutter_app/constants/api.dart';
import 'package:shop_flutter_app/exceptions/http_exception.dart';
import 'package:shop_flutter_app/models/product.dart';

class ProductList with ChangeNotifier {
  final String _urlProduct = "$api/products";
  final String _urlUserProductFavorites = "$api/userProductFavorites";
  final String _token;
  final String _userId;

  List<Product> _items = [];

  ProductList([this._token = '', this._userId = '', this._items = const []]);

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();

  int get itemsCount => _items.length;

  Future<bool> addProduct(Product product) async {
    // https://i.natgeofe.com/n/4f5aaece-3300-41a4-b2a8-ed2708a0a27c/domestic-dog_thumb_square.jpg?w=136&h=136
    // https://i.dell.com/is/image/DellContent/content/dam/images/products/electronics-and-accessories/dell/keyboards/kb700/kb700-kbm-02-gy.psd?fmt=pjpg&pscan=auto&scl=1&wid=4859&hei=2724&qlt=100,1&resMode=sharp2&size=4859,2724&chrss=full&imwidth=5000
    // https://upload.wikimedia.org/wikipedia/commons/a/a4/2019_Toyota_Corolla_Icon_Tech_VVT-i_Hybrid_1.8.jpg
    // https://www.oitomeia.com.br/wp-content/uploads/2023/06/PR-GTM-GOL-Laranjao.jpg
    try {
      final resp = await http.post(
        Uri.parse(
          '$_urlProduct.json?auth=$_token',
        ),
        body: jsonEncode({
          "name": product.name,
          "description": product.description,
          // "isFavorite": product.isFavorite,
          "price": product.price,
          "imageUrl": product.imageUrl,
        }),
      );
      final body = jsonDecode(resp.body);
      String productIdFirebase = body['name'] as String;
      product.id = productIdFirebase;
      _items.add(product);
      notifyListeners();
      return resp.statusCode == 200 ||
          resp.statusCode == 204 ||
          resp.statusCode == 201;
    } catch (ex) {
      return false;
    }
  }

  Future<bool> loadProducts() async {
    List<Product> items = [];

    try {
      final respProducts = await http.get(
        Uri.parse(
          '$_urlProduct.json?auth=$_token',
        ),
      );
      final dynamic bodyProducts = jsonDecode(respProducts.body);
      if (bodyProducts == null) {
        // when the products is empty, firebase returns null on body
        return true;
      }

      Map<String, dynamic> productIsFavorite = await _getIsfavorites();

      bodyProducts.forEach((productId, productData) {
        final bool isFavorite = productIsFavorite[productId] ?? false;
        items.add(
          Product(
            id: productId,
            name: productData['name'] as String,
            description: productData['description'] as String,
            price: productData['price'] as double,
            imageUrl: productData['imageUrl'] as String,
            isFavorite: isFavorite,
          ),
        );
      });

      _items = items.reversed.toList();
      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<Map<String, dynamic>> _getIsfavorites() async {
    final resp = await http.get(
      Uri.parse(
        '$_urlUserProductFavorites/$_userId.json?auth=$_token',
      ),
    );

    if (resp.statusCode >= 400) {
      throw HttpException(
        message:
            'Não foi possível realizar essa operação. Tente novamente mais tarde',
        status: 400,
      );
    }

    dynamic isFavoriteBody = jsonDecode(resp.body);
    if (isFavoriteBody == null) {
      // when the products is empty, firebase returns null on body
      return {};
    }

    return isFavoriteBody != null ? isFavoriteBody as Map<String, dynamic> : {};
  }

  void _toggleFavorite(int index) {
    _items[index].isFavorite = !_items[index].isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite(String productId) async {
    final int index = _items.indexWhere((element) => element.id == productId);
    if (index == -1) {
      throw HttpException(
        message: 'Não foi possível favoritar. Tente novamente mais tarde',
        status: 400,
      );
    }
    try {
      if (index >= 0) {
        _toggleFavorite(index);

        final resp = await http.put(
          Uri.parse(
            '$_urlUserProductFavorites/$_userId/$productId.json?auth=$_token',
          ),
          body: jsonEncode(_items[index].isFavorite),
        );
        if (resp.statusCode >= 400) {
          _toggleFavorite(index);
          throw HttpException(
            message: 'Não foi possível favoritar. Tente novamente mais tarde',
            status: 400,
          );
        }
      }
    } catch (ex) {
      _toggleFavorite(index);
      rethrow;
    }
  }

  Future<bool> updateProduct(Product product) async {
    final int index = _items.indexWhere((element) => element.id == product.id);
    if (index >= 0) {
      await http.patch(
        Uri.parse(
          '$_urlProduct/${product.id}.json?auth=$_token',
        ),
        body: jsonEncode({
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
        }),
      );

      _items[index] = product;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> removeProduct(Product product) async {
    try {
      final int index =
          _items.indexWhere((element) => element.id == product.id);
      if (index >= 0) {
        _items.removeAt(index);
      } else {
        throw HttpException(
            message: 'Esse produto não existe mais', status: 404);
      }

      final resp = await http.delete(
        Uri.parse(
          '$_urlProduct/${product.id}.json?auth=$_token',
        ),
        body: jsonEncode({
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
        }),
      );

      if (resp.statusCode >= 400) {
        addProduct(product);
        if (resp.statusCode == 404) {
          throw HttpException(
              message: 'Esse produto não existe mais', status: 404);
        } else {
          throw HttpException(
              message:
                  'Erro ao tentar remover o produto. Tente novamente mais tarde.',
              status: 404);
        }
      }
    } catch (ex) {
      throw HttpException(
          message:
              'Erro ao tentar remover o produto. Tente novamente mais tarde.',
          status: 404);
    } finally {
      notifyListeners();
    }
  }
}
