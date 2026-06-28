import 'dart:math';

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
    print("🧪 AdventureEngine.runTest START");
    print("skill: $skill");
    print("modifier: $modifier");

    final target = (skill + modifier).clamp(1, 100);
    final roll = _rng.nextInt(100) + 1;

    print("calculated target: $target");
    print("rolled value: $roll");

    final result = roll <= target ? "SUCCESS" : "FAIL";

    print("FINAL RESULT: $result");

    return TestResult(
      roll: roll,
      target: target,
      result: result,
    );
  }
}