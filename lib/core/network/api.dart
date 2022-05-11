/// API [API] : Contains the apis used in the app
class API {
  static const String baseUrl =
      "https://petcarecommerce-b065e-default-rtdb.firebaseio.com";
  static const String nodeJsURL = "https://petcarecommerce-api.herokuapp.com/";
  static const String users = baseUrl + "/users/";
  static const String admins = baseUrl + "/admins/";
  static const String products = baseUrl + "/products.json";
  static const String productId = baseUrl + "/products/";
  static const String orders = baseUrl + "/orders/";
  static const String toggleFavourite = baseUrl + "/usersFavourites/";
}
