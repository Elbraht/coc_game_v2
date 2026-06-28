import 'dart:math';

enum RollResult {
  criticalFailure,
  failure,
  success,
  hardSuccess,
  extremeSuccess,
  criticalSuccess,
}

class RollOutcome {
  final int roll;
  final int skill;
  final RollResult result;

  RollOutcome({
    required this.roll,
    required this.skill,
    required this.result,
  });
}

class RollSystem {
  static final Random _rng = Random();

  static int rollD100() => _rng.nextInt(100) + 1;

  static RollOutcome test(String name, int skill) {
    final roll = rollD100();
    final result = evaluate(roll, skill);

    return RollOutcome(
      roll: roll,
      skill: skill,
      result: result,
    );
  }

  static RollResult evaluate(int roll, int skill) {
    if (roll >= 96) return RollResult.criticalFailure;
    if (roll > skill) return RollResult.failure;

    final hard = (skill * 0.5).floor();
    final extreme = (skill * 0.2).floor();

    if (roll <= 1) return RollResult.criticalSuccess;
    if (roll <= extreme) return RollResult.extremeSuccess;
    if (roll <= hard) return RollResult.hardSuccess;

    return RollResult.success;
  }

  static String resultToText(RollResult r) {
    switch (r) {
      case RollResult.criticalFailure:
        return "KRYTYCZNA PORAŻKA";
      case RollResult.failure:
        return "PORAŻKA";
      case RollResult.success:
        return "SUKCES";
      case RollResult.hardSuccess:
        return "TRUDNY SUKCES";
      case RollResult.extremeSuccess:
        return "EKSTREMALNY SUKCES";
      case RollResult.criticalSuccess:
        return "KRYTYCZNY SUKCES";
    }
  }
}