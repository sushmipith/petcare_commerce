import 'package:get_it/get_it.dart';
import 'package:petcare_commerce/core/network/http_service.dart';
import 'package:petcare_commerce/providers/auth_provider.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // * Http Service
  locator.registerLazySingleton<HttpService>(() => HttpService());

  // * Auth Provider
  locator.registerLazySingleton<AuthProvider>(() => AuthProvider());
}
