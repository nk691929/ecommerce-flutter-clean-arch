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

  Timer? _debounceTimer;
  String _searchQuary = '';

  String? _selectedCategory;

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
  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore) return;

    _isLoadingMore = true;
    final currentProducts = state.value ?? [];

    final result = await _repository.getProducts(skip: _skip, limit: _limit);

    switch (result) {
      case Success(data: final newProducts):
        _skip += newProducts.length;
        _hasMore = newProducts.length == _limit;
        state = AsyncValue.data([...currentProducts, ...newProducts]);
      case Error():
        state = AsyncValue.data(currentProducts);
    }
    _isLoadingMore = false;
  }

  //searching product
  void search(String quarry) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _searchQuary = quarry;
      _skip = 0;
      _hasMore = true;
      state = const AsyncValue.loading();
      state = AsyncValue.data(state.value ?? []);
      _fetchWithSearch();
    });
  }

  //fetching searched product
  Future<void> _fetchWithSearch() async {
    final result = await _repository.getProducts(
      skip: _skip,
      limit: _limit,
      query: _searchQuary,
    );

    switch (result) {
      case Success(data: final searchedProducts):
        _skip = searchedProducts.length;
        _hasMore = searchedProducts.length == _limit;
        state = AsyncValue.data(searchedProducts);
      case Error(failure: final failure):
        state = AsyncValue.error(failure, StackTrace.current);
    }
  }

  void filterByCategory(String? category) {
    _selectedCategory = category;
    _skip = 0;
    _hasMore = true;
    state = AsyncValue.loading();
    _fetchFiltered();
  }

  Future<void> _fetchFiltered() async {
    final result = await _repository.getProducts(
      skip: _skip,
      limit: _limit,
      query: _searchQuary,
      category: _selectedCategory,
    );

    switch (result) {
      case Success(data: final filteredProducts):
        _skip = filteredProducts.length;
        _hasMore = filteredProducts.length == _limit;
        state = AsyncValue.data(filteredProducts);
      case Error(failure: final failure):
        {
          state = AsyncValue.error(failure, StackTrace.current);
        }
    }
  }
}

final productsProvider = AsyncNotifierProvider<ProductNotifier, List<Product>>(
  () => ProductNotifier(),
);
