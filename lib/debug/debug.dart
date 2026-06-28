import 'package:flutter/foundation.dart';

class D {
  static void log(String msg) {
    if (kDebugMode) {
      debugPrint("🟡 DEBUG: $msg");
    }
  }
}
