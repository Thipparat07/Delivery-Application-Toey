import 'dart:convert';

import 'package:flutter/services.dart';

class Configuration {
  static Future<Map<String, dynamic>> getConfig() {
    return rootBundle.loadString('asset/config/config.json').then(
          (value) => jsonDecode(value) as Map<String, dynamic>,
        );
  }
}