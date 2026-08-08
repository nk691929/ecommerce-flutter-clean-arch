import 'package:ecommerce_app/features/cart/domain/entities/cart_item.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';

class CartItemModel extends CartItem {
  CartItemModel({required super.product, required super.quantity});
  Map<String, dynamic> toJson() => {
    'product': {
      'id': product.id,
      'title': product.title,
      'description': product.description,
      'price': product.price,
      'category': product.category,
      'thumbnail': product.thumbnail,
      'stock': product.stock,
    },
    'quantity': quantity,
  };

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final p = json['product'];
    return CartItemModel(
      product: Product(
        id: p['id'],
        title: p['title'],
        description: p['description'],
        price: p['price'],
        category: p['category'],
        thumbnail: p['thumbnail'],
        stock: p['stock'],
      ),
      quantity: json['quantity'],
    );
  }
}
