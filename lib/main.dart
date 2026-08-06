import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'features/products/data/repositories/product_repositor_imp.dart';
import 'core/errors/result.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));
  final repository = ProductRepositorImp(dio);

  final result = await repository.getProducts(skip: 0, limit: 5);

  switch (result) {
    case Success(data: final products):
      print('✅ SUCCESS: Fetched ${products.length} products');
      for (var product in products) {
        print('  - ${product.title} (\$${product.price})');
      }
    case Error(failure: final failure):
      print('❌ ERROR: ${failure.message}');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: Text('Check console for test output')),
      ),
    );
  }
}
