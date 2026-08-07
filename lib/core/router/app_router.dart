import 'package:ecommerce_app/features/products/presentation/screens/product_list_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const ProductListScreen()),
  ],
);
