import 'package:ecommerce_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: cartItems.isEmpty
          ? Center(child: Text("No Item in cart"))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: Image.network(
                    item.product.thumbnail,
                    height: 50,
                    width: 50,
                  ),
                  title: Text(item.product.title),
                  subtitle: Text(
                    'Qty ${item.quantity} . ${item.totalPrize.toStringAsFixed(2)}',
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      ref
                          .read(cartProvider.notifier)
                          .removeFromCart(item.product.id);
                    },
                    icon: Icon(Icons.delete),
                  ),
                );
              },
            ),
    );
  }
}
