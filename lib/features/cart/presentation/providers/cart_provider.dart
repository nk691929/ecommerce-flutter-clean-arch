import 'dart:async';
import 'dart:convert';

import 'package:ecommerce_app/features/cart/data/models/cart_item_model.dart';
import 'package:ecommerce_app/features/cart/domain/entities/cart_item.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CartNotifier extends AsyncNotifier<List<CartItem>> {
  static const _storageKey = 'cart_items';
  @override
  Future<List<CartItem>> build() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_storageKey);
    if (saved != null) {
      final List<dynamic> decoded = jsonDecode(saved);
      return decoded.map((item) => CartItemModel.fromJson(item)).toList();
    }
    return [];
  }

  Future<void> _saveCart(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      items
          .map(
            (item) => CartItemModel(
              product: item.product,
              quantity: item.quantity,
            ).toJson(),
          )
          .toList(),
    );
    await prefs.setString(_storageKey, encoded);
  }

  void addToCart(Product product) {
    final currentItems = state.value ?? [];
    final existingIndex = currentItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    List<CartItem> updated;
    if (existingIndex != -1) {
      updated = [...currentItems];
      updated[existingIndex] = updated[existingIndex].copyWith(
        quantity: updated[existingIndex].quantity + 1,
      );
    } else {
      updated = [...currentItems, CartItem(product: product, quantity: 1)];
    }

    state = AsyncValue.data(updated);
    _saveCart(updated);
  }

  void removeFromCart(int productId) {
    final currentItems = state.value ?? [];
    final updated = currentItems
        .where((item) => item.product.id != productId)
        .toList();
    state = AsyncValue.data(updated);
    _saveCart(updated);
  }
}


final cartProvider = AsyncNotifierProvider<CartNotifier, List<CartItem>>(() => CartNotifier());