import 'package:ecommerce_app/core/errors/result.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';

abstract class ProductRepository {
  Future<Result<List<Product>>> getProducts({
    required int skip,
    required int limit,
  });
}
