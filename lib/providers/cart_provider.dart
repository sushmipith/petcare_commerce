import 'package:flutter/material.dart';
import '../models/cart_model.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartModel> _items = {};

  Map<String, CartModel> get items {
    return {..._items};
  }

  // add items to cart
  void addToCart(String productId, String title, double price) {
    //check if the item is already added
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartModel) => CartModel(
              id: existingCartModel.id,
              title: existingCartModel.title,
              price: existingCartModel.price,
              quantity: existingCartModel.quantity + 1));
    }
    // if item is not added
    else {
      _items.putIfAbsent(
          productId,
          () => CartModel(
              id: productId, title: title, price: price, quantity: 1));
    }
    notifyListeners();
  }

  // get total items in cart
  int get totalCount {
    return _items.length;
  }

  //remove a single item from cart
  void removeSingleItem(String cartId) {
    if (!_items.containsKey(cartId)) {
      return;
    }
    if (_items[cartId]!.quantity > 1) {
      _items.update(
          cartId,
          (existingCartModel) => CartModel(
              id: existingCartModel.id,
              title: existingCartModel.title,
              price: existingCartModel.price,
              quantity: existingCartModel.quantity - 1));
    } else {
      _items.remove(cartId);
    }
    notifyListeners();
  }

  //total amount of the cart
  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartModel) {
      total += cartModel.price * cartModel.quantity;
    });
    return total;
  }

  // remove a item from cart
  void removeItem(String cartId) {
    if (!_items.containsKey(cartId)) {
      return;
    }
    _items.remove(cartId);
    notifyListeners();
  }

  //clear cart
  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
