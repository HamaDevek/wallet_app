import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wallet_app/controllers/auth_controller.dart';

class HttpHelper {
  // Singleton instance
  static final HttpHelper instance = HttpHelper._internal();
  factory HttpHelper() => instance;
  HttpHelper._internal();

  // Get headers with optional authorization
  Future<Map<String, String>> _getHeaders() async {
    String? token = await getToken();
    print('Auth Token: $token');
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Dummy token retrieval (replace with your own logic!)
  Future<String?> getToken() async {
    String? token = AuthController.to.user.value?.data?.token;
    if (token != null && token.isNotEmpty) {
      return token;
    }
    return null;
  }

  /// Core request function for GET/POST/PUT/DELETE
  Future<http.Response> _sendRequest(
    String endpoint,
    String method, {
    Map<String, dynamic>? body,
    Map<String, String>? urlParameter,
  }) async {
    Uri url = Uri.parse(endpoint);

    if (urlParameter != null && urlParameter.isNotEmpty) {
      url = url.replace(
        queryParameters: {...url.queryParameters, ...urlParameter},
      );
    }

    final headers = await _getHeaders();
    final requestBody = jsonEncode({
      if (body != null) ...body,
      if (method != 'POST' && method != 'GET') '_method': method,
    });

    print('URL: $url');
    print('Request Body: $requestBody');

    if (method == 'GET') {
      return await http.get(url, headers: headers);
    }

    // Use POST for all except GET
    return await http.post(url, headers: headers, body: requestBody);
  }

  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? urlParameter,
  }) async {
    return _sendRequest(endpoint, 'GET', urlParameter: urlParameter);
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    return _sendRequest(endpoint, 'POST', body: body);
  }

  Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    return _sendRequest(endpoint, 'PUT', body: body);
  }

  Future<http.Response> delete(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    return _sendRequest(endpoint, 'DELETE', body: body);
  }
}
