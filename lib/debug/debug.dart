import 'package:flutter/foundation.dart';

class D {
  static void log(String msg) {
    if (kDebugMode) {
      // ignore: avoid_print
      print("🟡 DEBUG: $msg");
    }
  }
}