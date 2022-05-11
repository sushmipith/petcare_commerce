import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../service/service_locator.dart';
import '../../providers/auth_provider.dart';

/// Service [HttpService] : HttpService lets you connect to the network with token
class HttpService {
  Future<http.Response> get(
    String url,
  ) async {
    try {
      String? token = locator<AuthProvider>().token;
      final response = await http.get(Uri.parse(url + "?auth=$token"));
      if (response.statusCode != 200) {
        final checkAuth = json.decode(response.body) as Map<String, dynamic>;
        if (checkAuth.containsKey("error")) {
          throw const HttpException("Auth Expired, Please Re-login");
        }
        throw const HttpException('Something went wrong!');
      }
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> post(
    String url, {
    required dynamic body,
  }) async {
    try {
      String? token = locator<AuthProvider>().token;
      final response =
          await http.post(Uri.parse(url + "?auth=$token"), body: body);
      if (response.statusCode != 200) {
        throw const HttpException('Something went wrong!');
      }
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> put(
    String url, {
    dynamic body,
  }) async {
    try {
      String? token = locator<AuthProvider>().token;
      final response =
          await http.put(Uri.parse(url + "?auth=$token"), body: body);
      if (response.statusCode != 200) {
        throw const HttpException('Something went wrong!');
      }
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> delete(String url) async {
    try {
      String? token = locator<AuthProvider>().token;
      final response = await http.delete(Uri.parse(url + "?auth=$token"));
      if (response.statusCode != 200) {
        throw const HttpException('Something went wrong!');
      }
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> patch(String url, {dynamic body}) async {
    try {
      String? token = locator<AuthProvider>().token;
      final response =
          await http.patch(Uri.parse(url + "?auth=$token"), body: body);
      if (response.statusCode != 200) {
        throw const HttpException('Something went wrong!');
      }
      return response;
    } catch (error) {
      rethrow;
    }
  }
}
