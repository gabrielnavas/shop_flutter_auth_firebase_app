import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/exceptions/http_exception.dart';
import 'package:shop_flutter_app/models/cart.dart';
import 'package:shop_flutter_app/models/product.dart';
import 'package:shop_flutter_app/providers/product_list.dart';
import 'package:shop_flutter_app/routes.dart';

class ProductGridItem extends StatelessWidget {
  final Product product;

  const ProductGridItem({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    // not change UI (performatic)
    final Product product = Provider.of<Product>(context);
    final Cart cart = Provider.of<Cart>(context);

    // grid with rows and columns
    Widget gridTileProduct = GridTile(
      footer: GridTileBar(
        title: Text(
          product.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11.4,
            fontFamily: 'Lato',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(208, 0, 0, 0),
        leading: IconButton(
          icon:
              Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
          onPressed: () async {
            try {
              await Provider.of<ProductList>(context, listen: false)
                  .toggleFavorite(product.id);
            } on HttpException catch (ex) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(ex.message),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
            // product.toggleFavorite();
          },
          color: Colors.redAccent,
        ),
        trailing: IconButton(
          icon: Icon(
            cart.exist(product)
                ? Icons.shopping_cart
                : Icons.shopping_cart_outlined,
          ),
          onPressed: () {
            if (cart.exist(product)) {
              cart.remove(product.id);
            } else {
              cart.add(product);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Produto adicionado!'),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'Desfazer',
                    onPressed: () => cart.remove(product.id),
                  ),
                ),
              );
            }
          },
          color: const Color.fromARGB(204, 255, 234, 0),
        ),
      ),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(
          Routes.productDetail,
          arguments: product,
        ),
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );

    // clip an element, on border this case
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: gridTileProduct,
    );
  }
}
