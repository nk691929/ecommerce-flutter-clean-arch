import 'package:ecommerce_app/features/products/presentation/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(productsProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productsProvider);
    final categories = [
      'smartphones',
      'laptops',
      'fragrances',
      'skincare',
      'beauty',
    ];
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hint: Text("Search products"),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            ref.read(productsProvider.notifier).search(value);
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: categories.map((cat) {
                return Padding(
                  padding: const EdgeInsetsGeometry.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: false,
                    onSelected: (_) => ref
                        .read(productsProvider.notifier)
                        .filterByCategory(cat),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: productAsync.when(
              data: (products) {
                return ListView.builder(
                  itemCount: products.length,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ListTile(
                      leading: Image.network(
                        product.thumbnail,
                        height: 50,
                        width: 50,
                      ),
                      title: Text(product.title),
                      subtitle: Text(product.description),
                      trailing: Text(product.price.toString()),
                      onTap: () =>
                          context.push('/product/${product.id}', extra: product),
                    );
                  },
                );
              },
              error: (error, stack) => Center(child: Text('Error: $error.')),
              loading: () => Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
