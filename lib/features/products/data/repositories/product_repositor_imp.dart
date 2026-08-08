import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/errors/failure.dart';
import 'package:ecommerce_app/core/errors/result.dart';
import 'package:ecommerce_app/features/products/data/models/product_model.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:ecommerce_app/features/products/domain/repositories/product_repository.dart';

class ProductRepositorImp implements ProductRepository {
  final Dio dio;
  ProductRepositorImp(this.dio);

  @override
  Future<Result<List<Product>>> getProducts({
    required int skip,
    required int limit,
    String? query,
    String? category,
  }) async {
    try {
      final bool isSearching = query != null && query.isNotEmpty;
      final bool isFiltering = category != null && category.isNotEmpty;

      String endpoint = '/products';
      if (isSearching) {
        endpoint = '/products/search';
      } else if (isFiltering) {
        endpoint = '/products/category/$category';
      }

      final response = await dio.get(
        endpoint,
        queryParameters: {
          'skip': skip,
          'limit': limit,
          if (query != null && query.isNotEmpty) 'q': query,
        },
      );

      final List<dynamic> productJson = response.data['products'];
      final products = productJson
          .map((json) => ProductModel.fromJson(json))
          .toList();

      return Success(products);
    } on DioException catch (e) {
      return Error(NetworkFailure(e.message ?? "Network Error Occured"));
    } catch (e) {
      print(e.toString());
      return Error(ParsingFailure('Failed to parse products: $e'));
    }
  }
}
