import 'package:get_it/get_it.dart';
import '../network/http_service.dart';
import '../../providers/admin_order_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/products_provider.dart';

GetIt locator = GetIt.instance;

/// FUNC [setupLocator] : setupLocator service makes the services and providers a singleton
Future<void> setupLocator() async {
  // * Http Service
  locator.registerLazySingleton<HttpService>(() => HttpService());

  // * Auth Provider
  locator.registerLazySingleton<AuthProvider>(() => AuthProvider());

  // * Products Provider
  locator.registerLazySingleton<ProductsProvider>(() => ProductsProvider());

  // * Cart Provider
  locator.registerLazySingleton<CartProvider>(() => CartProvider());

  // * Order Provider
  locator.registerLazySingleton<OrderProvider>(() => OrderProvider());

  // * Admin Order Provider
  locator.registerLazySingleton<AdminOrderProvider>(() => AdminOrderProvider());
}
