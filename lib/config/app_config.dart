import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfig {
  static String baseUrl = 'https://affiliate.coderz.online';
  static String licenseKey = '12345678-1234-1234-1234-1234567890ab';

  static Future<void> load() async {
    final String response = await rootBundle.loadString('assets/config.json');
    final data = json.decode(response);
    baseUrl = data['base_url'];
    licenseKey = data['license_key'];
  }
}