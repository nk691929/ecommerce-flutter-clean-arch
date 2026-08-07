import 'package:ecommerce_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailScreen extends ConsumerWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                product.thumbnail,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),
              Text(
                product.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 8),
              Text(
                "\$${product.price}",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 16),
              Text(product.description),
              SizedBox(height: 8),
              Text('In stock: ${product.stock}'),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(cartProvider.notifier).addToCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Successfullt added to cart'),
                      ),
                    );
                  },
                  child: Text("Add to cart"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
