import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:petcare_commerce/core/network/http_service.dart';
import 'package:petcare_commerce/core/service/service_locator.dart';
import 'package:petcare_commerce/models/product_model.dart';
import 'package:petcare_commerce/providers/auth_provider.dart';

import '../core/network/API.dart';

class ProductsProvider with ChangeNotifier {
  List<ProductModel> _products = [];
  final HttpService httpService = locator<HttpService>();

  //Get the product list
  List<ProductModel> get products {
    return [..._products];
  }

  //Get the flash sale product list
  List<ProductModel> get flashSaleProducts {
    return [..._products.where((prod) => prod.type == "Flash").toList()];
  }

  //Get the flash sale product list
  List<ProductModel> getCategoryProduct(String category) {
    return [..._products.where((prod) => prod.category == category).toList()];
  }

  //Get the flash sale product list
  List<ProductModel> get newProducts {
    return [..._products.where((prod) => prod.type == "New").toList()];
  }

  //Get the favourite product list
  List<ProductModel> get favProducts {
    return [..._products.where((prod) => prod.isFavourite).toList()];
  }

  // Find product by id
  ProductModel findProductById(String id) {
    return _products.firstWhere((prod) => prod.id == id);
  }

  // toggle favourites
  Future<void> toggleFavourite(String id) async {
    ProductModel toggleProduct = _products.firstWhere((prod) => prod.id == id);
    final oldStatus = toggleProduct.isFavourite;
    toggleProduct.isFavourite = !toggleProduct.isFavourite;
    notifyListeners();
    //post data and if any error reverse old status
    try {
      String? userId = locator<AuthProvider>().userId;
      await httpService.put(API.toggleFavourite + "$userId/$id.json",
          body: json.encode(toggleProduct.isFavourite));
    } catch (error) {
      toggleProduct.isFavourite = oldStatus;
      notifyListeners();
    }
  }

  // fetch all the product from firebase
  Future<void> fetchAllProducts() async {
    try {
      final response = await httpService.get(API.products);
      final allMap = json.decode(response.body) as Map<String, dynamic>;

      //fetch favourite api also
      String? userId = locator<AuthProvider>().userId;
      final favouriteResponse =
          await httpService.get(API.toggleFavourite + "$userId.json");
      final favouriteData = json.decode(favouriteResponse.body);

      List<ProductModel> allProducts = [];
      allMap.forEach((prodId, prodData) {
        allProducts.add(ProductModel(
            id: prodId,
            type: prodData['type'],
            category: prodData['category'],
            title: prodData['title'],
            description: prodData['description'],
            rating: prodData['rating'],
            price: double.tryParse(prodData["price"].toString()) ?? 0,
            imageURL: prodData['imageURL'],
            isFavourite: favouriteData == null
                ? false
                : favouriteData[prodId] ?? false));
      });
      _products = allProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  //add product
  Future<void> addProduct(ProductModel addProduct, File imageFile) async {
    //add to firebase
    try {
      final Map<String, dynamic> addMap = {
        "type": addProduct.type,
        "category": addProduct.category,
        "title": addProduct.title,
        "description": addProduct.description,
        "rating": addProduct.rating,
        "price": addProduct.price,
        "imageURL": "",
      };
      if (imageFile != null) {
        addMap["imageURL"] =
            await uploadProductPhoto(DateTime.now().toString(), imageFile);
        addProduct.imageURL = addMap["imageURL"];
      }
      final response =
          await httpService.post(API.products, body: json.encode(addMap));
      print(response.body);
      final id = json.decode(response.body);
      final newProduct = ProductModel(
        id: id["name"],
        type: addProduct.type,
        category: addProduct.category,
        title: addProduct.title,
        description: addProduct.description,
        rating: addProduct.rating,
        price: addProduct.price,
        imageURL: addProduct.imageURL,
      );
      _products.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  //update product
  Future<void> updateProduct(String id, ProductModel updatedProduct,
      String prevImageUrl, File imageFile) async {
    try {
      final prodIndex = _products.indexWhere((prod) => prod.id == id);
      Map updateMap = {
        "type": updatedProduct.type,
        "category": updatedProduct.category,
        "title": updatedProduct.title,
        "description": updatedProduct.description,
        "rating": updatedProduct.rating,
        "price": updatedProduct.price,
        "imageURL": prevImageUrl,
      };
      if (imageFile != null) {
        updateMap["imageURL"] = await uploadProductPhoto(id, imageFile);
        updatedProduct.imageURL = updateMap["imageURL"];
      }
      final response = await httpService.patch(
          API.baseUrl + "/products/$id.json",
          body: json.encode(updateMap));
      print(response.body);
      final editedProduct = ProductModel(
        id: updatedProduct.id,
        type: updatedProduct.type,
        category: updatedProduct.category,
        title: updatedProduct.title,
        description: updatedProduct.description,
        rating: updatedProduct.rating,
        price: updatedProduct.price,
        imageURL: imageFile == null ? prevImageUrl : updateMap["imageURL"],
      );
      _products.removeAt(prodIndex);
      _products.add(editedProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  //delete product
  Future<void> deleteProduct(String productId) async {
    try {
      final prodIndex = _products.indexWhere((prod) => prod.id == productId);
      ProductModel existingProduct = _products[prodIndex];
      //remove the product
      _products.removeAt(prodIndex);
      notifyListeners();
      final response =
          await httpService.delete(API.baseUrl + "/products/$productId.json");
      // if firebase could not delete
      if (response.statusCode >= 400) {
        _products.insert(prodIndex, existingProduct);
        notifyListeners();
        throw const HttpException("Could not be deleted! Try again!");
      }
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  // Upload product photo to firebase
  Future<String> uploadProductPhoto(String productId, File imageFile) async {
    try {
      String imageFileName = imageFile.path.split('/').last;
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('products/$productId/$imageFileName');

      UploadTask uploadTask = storageRef.putFile(imageFile);
      String imageUrl = await (await uploadTask).ref.getDownloadURL();
      return imageUrl;
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  // get search results according to query
  List<ProductModel> getSearchItems(String query) {
    if (query.isNotEmpty && query != null) {
      return _products
          .where((prod) => prod.title.toLowerCase().startsWith(query))
          .toList();
    }
    return [];
  }
}
