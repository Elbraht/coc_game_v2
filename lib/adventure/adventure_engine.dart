import 'dart:math';
import 'package:flutter/foundation.dart';

class TestResult {
  final int roll;
  final int target;
  final String result;

  TestResult({
    required this.roll,
    required this.target,
    required this.result,
  });
}

class AdventureEngine {
  final Random _rng = Random();

  TestResult runTest({
    required int skill,
    required int modifier,
  }) {
    debugPrint("🧪 AdventureEngine.runTest START");
    debugPrint("skill: $skill");
    debugPrint("modifier: $modifier");

    final target = (skill + modifier).clamp(1, 100);
    final roll = _rng.nextInt(100) + 1;

    debugPrint("calculated target: $target");
    debugPrint("rolled value: $roll");

    final result = roll <= target ? "SUCCESS" : "FAIL";

    debugPrint("FINAL RESULT: $result");

    return TestResult(
      roll: roll,
      target: target,
      result: result,
    );
  }
}
