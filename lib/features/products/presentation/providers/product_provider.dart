import 'dart:async';

import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/errors/result.dart';
import 'package:ecommerce_app/features/products/data/repositories/product_repositor_imp.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductNotifier extends AsyncNotifier<List<Product>> {
  int _skip = 0;
  final int _limit = 10;
  bool _isLoadingMore = false;
  bool _hasMore = false;

  late final ProductRepositorImp _repository;
  @override
  FutureOr<List<Product>> build() {
    _repository = ProductRepositorImp(
      Dio(BaseOptions(baseUrl: 'http://dummyjson.com')),
    );

    return _fetchInitialProduct();
  }

  //fetching products for the first time
  Future<List<Product>> _fetchInitialProduct() async {
    final result = await _repository.getProducts(skip: _skip, limit: _limit);
    switch (result) {
      case Success(data: final products):
        _skip = products.length;
        _hasMore = products.length == _limit;
        return products;
      case Error(failure: final failure):
        throw failure;
    }
  }

  //loading more products after first time
  Future<void> _loadMore() async {
    if (!_hasMore || _isLoadingMore) return;

    _isLoadingMore = true;
    final currentProducts = state.value ?? [];

    final result = await _repository.getProducts(skip: _skip, limit: _limit);

    switch (result) {
      case Success(data: final newProducts):
        _skip = newProducts.length;
        _hasMore = newProducts.length == _limit;
        state = AsyncValue.data([...currentProducts, ...newProducts]);
      case Error():
        state = AsyncValue.data(currentProducts);
    }
    _isLoadingMore = false;
  }
}

final productsProvider = AsyncNotifierProvider<ProductNotifier, List<Product>>(
  () => ProductNotifier(),
);
