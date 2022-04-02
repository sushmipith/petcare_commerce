import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:petcare_commerce/core/service/service_locator.dart';
import 'package:petcare_commerce/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpService {
  Future<dynamic> get(
    String url,
  ) async {
    try {
      String? token = locator<AuthProvider>().token;
      final response = await http.get(Uri.parse(url + "?auth=$token"));
      if (response.statusCode != 200) {
        return const HttpException('Something went wrong!');
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
        return const HttpException('Something went wrong!');
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
          await http.post(Uri.parse(url + "?auth=$token"), body: body);
      if (response.statusCode != 200) {
        return const HttpException('Something went wrong!');
      }
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> delete(String url) async {
    try {
      String? token = locator<AuthProvider>().token;
      final response = await http.post(Uri.parse(url + "?auth=$token"));
      if (response.statusCode != 200) {
        return const HttpException('Something went wrong!');
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
        return const HttpException('Something went wrong!');
      }
      return response;
    } catch (error) {
      rethrow;
    }
  }
}
