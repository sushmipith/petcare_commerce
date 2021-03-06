import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/exception/auth_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/api.dart';

/// Provider [AuthProvider] : AuthProvider handles authentication and user profile information
class AuthProvider with ChangeNotifier {
  String? _userId;
  String? _currentUsername;
  bool _isAdmin = false;
  String? _authToken;
  DateTime? _expiryDate;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Timer? _authTimer;

  // get if is authenticated
  bool get isAuth {
    return _authToken != null;
  }

  // get token for apis
  String? get token {
    return _authToken;
  }

  // get userid
  String? get userId {
    return _userId;
  }

  // get username
  String? get currentUsername {
    return _currentUsername;
  }

  // get userid
  bool get isAdmin {
    return _isAdmin;
  }

  /// sign in user with firebase
  Future<void> _authenticate(
      String username, String email, String password, String type) async {
    try {
      UserCredential response;
      if (type == "signIn") {
        response = await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        response = await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
      }
      //get user id and get auth token
      _userId = response.user?.uid;
      final idTokenResult = await _firebaseAuth.currentUser!.getIdTokenResult();
      _authToken = idTokenResult.token;
      final expirationDuration =
          idTokenResult.expirationTime?.difference(DateTime.now());
      _expiryDate = DateTime.now().add(expirationDuration!);
      //auto logout if token expired
      _autoLogout();
      notifyListeners();

      //get user data if its sign in
      String profileURL = "";
      if (type == "signIn") {
        final extractedData = await _getUserData(_userId!);
        profileURL = extractedData["profileURL"];
        username = extractedData["username"];
        _isAdmin = extractedData["isAdmin"] ?? false;
      } else {
        await _addNewUser(response.user?.uid, username, email);
      }
      //save to shared prefs
      _currentUsername = username;
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token": _authToken,
        "userId": _userId,
        "isAdmin": _isAdmin,
        "expiryDate": _expiryDate?.toIso8601String(),
        "email": email,
        "username": username,
      });
      prefs.setString("userData", userData);
      prefs.setString("profileURL", profileURL);
    } catch (error) {
      AuthResultStatus status = AuthResultException.handleException(error);
      String message = AuthResultException.generatedExceptionMessage(status);
      throw message;
    }
  }

  /// sign in user with firebase
  Future<void> signIn(String email, String password) async {
    return _authenticate("", email, password, "signIn");
  }

  /// sign in user with firebase
  Future<void> signUp(String username, String email, String password) async {
    return _authenticate(username, email, password, "signUp");
  }

  // create new user in database
  Future<void> _addNewUser(
      String? userId, String username, String email) async {
    try {
      final addUser = {
        "username": username,
        "email": email,
        "profileURL": "",
      };
      await http.put(
          Uri.parse(API.users + "$userId.json" + "?auth=$_authToken"),
          body: json.encode(addUser));
      await http.put(Uri.parse(API.nodeJsURL + "/users"),
          body: json.encode(addUser));
    } catch (error) {
      rethrow;
    }
  }

  // create new user in database
  Future<Map<String, dynamic>> _getUserData(String userId) async {
    try {
      final response = await http
          .get(Uri.parse(API.users + "$userId.json" + "?auth=$_authToken"));
      var extractedData = json.decode(response.body) as Map<String, dynamic>;
      final adminResponse = await http
          .get(Uri.parse(API.admins + "$userId.json" + "?auth=$_authToken"));
      final extractedAdmin = json.decode(adminResponse.body);
      await http.get(Uri.parse(API.nodeJsURL + "/users/$userId"));
      extractedData.putIfAbsent('isAdmin', () => extractedAdmin == userId);
      return extractedData;
    } catch (error) {
      rethrow;
    }
  }

  // forgot password
  Future<void> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (error) {
      AuthResultStatus status = AuthResultException.handleException(error);
      String message = AuthResultException.generatedExceptionMessage(status);
      throw message;
    }
  }

  // reset password
  Future<void> resetPassword(String password, String code) async {
    try {
      await _firebaseAuth.confirmPasswordReset(
          code: code, newPassword: password);
    } catch (error) {
      AuthResultStatus status = AuthResultException.handleException(error);
      String message = AuthResultException.generatedExceptionMessage(status);
      throw message;
    }
  }

  //logout user
  Future<void> logout() async {
    try {
      _authToken = null;
      _userId = null;
      _expiryDate = null;
      _isAdmin = false;
      if (_authTimer != null) {
        _authTimer?.cancel();
        _authTimer = null;
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await _firebaseAuth.signOut();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  // auto logout user
  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }
    final timeToExpire = _expiryDate?.difference(DateTime.now());
    _authTimer = Timer(timeToExpire!, logout);
  }

  // auto login user
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    String? userData = prefs.getString("userData");
    Map<String, dynamic> extractedData = json.decode(userData!);
    final expiryDate =
        DateTime.tryParse(extractedData["expiryDate"].toString());
    _authToken = extractedData['token'];
    _userId = extractedData["userId"];
    _isAdmin = extractedData["isAdmin"] ?? false;
    if (_authToken == null || _userId == null) {
      return false;
    }
    _expiryDate = expiryDate;
    if (expiryDate!.isBefore(DateTime.now())) {
      return false;
    }
    // auto login start

    // start auto logout again for new timer
    notifyListeners();
    _autoLogout();
    return true;
  }

  // Upload product photo to firebase
  Future<void> uploadUserPhoto(File imageFile) async {
    try {
      String imageFileName = imageFile.path.split('/').last;
      Reference storageRef =
          FirebaseStorage.instance.ref().child('users/$_userId/$imageFileName');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      String imageUrl = await (await uploadTask).ref.getDownloadURL();
      await _addPhotoToDB(imageUrl);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("profileURL", imageUrl);
    } catch (error) {
      rethrow;
    }
  }

  // create new user in database
  Future<Map<String, dynamic>> _addPhotoToDB(String imageURL) async {
    try {
      final response = await http.put(Uri.parse(API.users + "$userId.json"),
          body: json.encode({
            "profileURL": imageURL,
          }));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      return extractedData;
    } catch (error) {
      rethrow;
    }
  }
}
