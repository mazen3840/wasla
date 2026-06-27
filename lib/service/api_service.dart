import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:affiliatepro_mobile/config/app_config.dart';


class ApiService {
  static final ApiService _instance = ApiService._internal();

  ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  static final ApiService instance = _instance;

  final Dio _dio = Dio();

  String get baseUrl => _baseUrl;

  final String _baseUrl = AppConfig.baseUrl;
  final String _licenseKey = AppConfig.licenseKey;

  Map<String, String> headers = {
    'content-Type': 'application/x-www-form-urlencoded'
  };

  Future<bool> validateLicense() async {
    final response = await postData('user/license_validate', {
      'license_key': _licenseKey,
    });

    if (response != null && response['status'] == true) {
      return true;
    } else {
      return false;
    }
  }


  Future<Map<String, dynamic>?> getData(String endPoint,
      {String? token}) async {
    try {
      String url = _baseUrl + endPoint;
      debugPrint('url : $url');
      Response response;
      if (token == null) {
        response = await _dio.get(url, options: Options(headers: headers));
      } else {
        headers['Authorization'] = token;
        response = await _dio.get(url, options: Options(headers: headers));
      }
      debugPrint('postData response : $response');
      return response.data;
    } catch (error) {
      debugPrint('getData error : $error');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getData2(
      String endPoint, num pageId, num perPage,
      {String? token}) async {
    try {
      String url = _baseUrl + endPoint;
      debugPrint('url : $url');
      Response response;
      if (token == null) {
        response = await _dio.get('$url?page_id=$pageId&per_page=$perPage',
            options: Options(headers: headers));
      } else {
        headers['Authorization'] = token;
        response = await _dio.get(url, options: Options(headers: headers));
      }
      debugPrint('postData response : $response');
      return response.data;
    } catch (error) {
      debugPrint('getData error : $error');
      return null;
    }
  }

  Future<Map<String, dynamic>?> postData(String endPoint, dynamic body) async {
    try {
      String url = _baseUrl + endPoint;
      debugPrint('url : $url');
      Response response = await _dio.post(url, data: body, options: Options(headers: headers));
      debugPrint('postData response : ${response.data}');

      if (response.data is Map<String, dynamic>) {
        return response.data;
      } else if (response.data is String) {
        // This will fix your issue
        return jsonDecode(response.data);
      } else {
        return null;
      }
    } catch (error) {
      debugPrint('postData error : $error');
      return null;
    }
  }


  Future<Map<String, dynamic>?> postData2(String endPoint, dynamic body,
      {String? token}) async {
    try {
      String url = _baseUrl + endPoint;
      debugPrint('url : $url');

      Response response;
      if (token == null) {
        response = await _dio.post(url,
            data: body, options: Options(headers: headers));
      } else {
        headers['Authorization'] = token;
        response = await _dio.post(url,
            data: body, options: Options(headers: headers));
      }
      debugPrint('postData response : $response');
      return response.data;
    } catch (error) {
      debugPrint('postData error : $error');
      return null;
    }
  }
}
