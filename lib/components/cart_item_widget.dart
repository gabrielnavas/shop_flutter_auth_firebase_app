import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/models/cart.dart';
import 'package:shop_flutter_app/models/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget(this.cartItem, {super.key});

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);

    return Dismissible(
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) {
        return showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Tem certeza?'),
            content: const Text('Quer remover o item do carrinho?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: const Text(
                  'Não',
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: const Text(
                  'Sim',
                ),
              )
            ],
          ),
        );
      },
      onDismissed: (_) {
        Provider.of<Cart>(
          context,
          listen: false,
        ).remove(
          cartItem.productId,
        );
      },
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        child: ListTile(
          leading: SizedBox(
            width: 70,
            height: 45,
            child: Image.network(
              cartItem.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(cartItem.productName),
          subtitle: Row(
            children: [
              Text(
                '${cartItem.quantity}x ${cartItem.productPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'R\$${(cartItem.productPrice * cartItem.quantity).toStringAsFixed(2)}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 12.5),
              ),
            ],
          ),
          trailing: Column(
            children: [
              Container(
                height: 28,
                decoration: const BoxDecoration(color: Colors.black45),
                child: IconButton(
                  iconSize: 16,
                  icon: const Icon(Icons.add),
                  color: Colors.white,
                  onPressed: () {
                    cart.incrementQuantity(cartItem.id);
                  },
                ),
              ),
              Container(
                height: 28,
                decoration: const BoxDecoration(color: Colors.black12),
                child: IconButton(
                  iconSize: 16,
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    cart.decrementQuantity(cartItem.id);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
