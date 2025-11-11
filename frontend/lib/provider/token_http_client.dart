import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:utility/provider/common_provider.dart';

class TokenAwareHttpClient {
  static Future<http.Response> get(
    Uri url, {
    required Map<String, String> headers,
    required BuildContext context,
  }) async {
    final provider = Provider.of<CommonProvider>(context, listen: false);
    final updatedHeaders = Map<String, String>.from(headers);

    var response = await http.get(url, headers: updatedHeaders);

    if (response.statusCode == 401) {
      final success = await provider.refreshAccessToken(context);
      if (!success || provider.accessToken == null) return response;

      updatedHeaders['Authorization'] = 'Bearer ${provider.accessToken}';
      response = await http.get(url, headers: updatedHeaders);
    }

    return response;
  }

  static Future<http.Response> post(
    Uri url, {
    required Map<String, String> headers,
    required Object body,
    required BuildContext context,
  }) async {
    final provider = Provider.of<CommonProvider>(context, listen: false);
    final updatedHeaders = Map<String, String>.from(headers);

    var response = await http.post(url, headers: updatedHeaders, body: body);

    if (response.statusCode == 401) {
      final success = await provider.refreshAccessToken(context);
      if (!success || provider.accessToken == null) return response;

      updatedHeaders['Authorization'] = 'Bearer ${provider.accessToken}';
      response = await http.post(url, headers: updatedHeaders, body: body);
    }

    return response;
  }

  static Future<http.Response> put(
    Uri url, {
    required Map<String, String> headers,
    required Object body,
    required BuildContext context,
  }) async {
    final provider = Provider.of<CommonProvider>(context, listen: false);
    final updatedHeaders = Map<String, String>.from(headers);

    var response = await http.put(url, headers: updatedHeaders, body: body);

    if (response.statusCode == 401) {
      final success = await provider.refreshAccessToken(context);
      if (!success || provider.accessToken == null) return response;

      updatedHeaders['Authorization'] = 'Bearer ${provider.accessToken}';
      response = await http.put(url, headers: updatedHeaders, body: body);
    }

    return response;
  }

  static Future<http.Response> delete(
    Uri url, {
    required Map<String, String> headers,
    required BuildContext context,
  }) async {
    final provider = Provider.of<CommonProvider>(context, listen: false);
    final updatedHeaders = Map<String, String>.from(headers);

    var response = await http.delete(url, headers: updatedHeaders);

    if (response.statusCode == 401) {
      final success = await provider.refreshAccessToken(context);
      if (!success || provider.accessToken == null) return response;

      updatedHeaders['Authorization'] = 'Bearer ${provider.accessToken}';
      response = await http.delete(url, headers: updatedHeaders);
    }

    return response;
  }
}
