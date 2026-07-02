import 'dart:math';
import 'package:coc_game_v2/adventure/adventure_node.dart';

enum RollResult {
  criticalFailure,
  failure,
  success,
  hardSuccess,
  extremeSuccess,
  criticalSuccess
}

class RollOutcome {
  final RollResult result;
  final int rollValue;
  RollOutcome({required this.result, required this.rollValue});
}

class RollSystem {
  static RollOutcome test(int skillValue, Difficulty diff, int bonusDice) {
    int target = skillValue;
    if (diff == Difficulty.hard) {
      target = (skillValue * 0.5).floor();
    }
    if (diff == Difficulty.extreme) {
      target = (skillValue * 0.2).floor();
    }

    final random = Random();
    int tens = random.nextInt(10);
    List<int> tensResults = [tens];
    for (int i = 0; i < bonusDice.abs(); i++) {
      tensResults.add(random.nextInt(10));
    }

    int finalTens =
        (bonusDice >= 0) ? tensResults.reduce(min) : tensResults.reduce(max);
    int units = random.nextInt(10);
    int roll = (finalTens == 0 && units == 0) ? 100 : (finalTens * 10 + units);

    RollResult result;
    if (roll >= 96) {
      result = RollResult.criticalFailure;
    } else if (roll <= (target * 0.2).floor()) {
      result = RollResult.extremeSuccess;
    } else if (roll <= (target * 0.5).floor()) {
      result = RollResult.hardSuccess;
    } else if (roll <= target) {
      result = RollResult.success;
    } else {
      result = RollResult.failure;
    }

    if (roll <= 1) {
      result = RollResult.criticalSuccess;
    }
    return RollOutcome(result: result, rollValue: roll);
  }

  static bool isWinner(
      RollOutcome p1, RollOutcome p2, int p1Skill, int p2Skill) {
    int score(RollResult r) {
      switch (r) {
        case RollResult.criticalSuccess:
          return 4;
        case RollResult.extremeSuccess:
          return 3;
        case RollResult.hardSuccess:
          return 2;
        case RollResult.success:
          return 1;
        default:
          return 0;
      }
    }

    int s1 = score(p1.result);
    int s2 = score(p2.result);
    if (s1 != s2) {
      return s1 > s2;
    }
    if (p1Skill != p2Skill) {
      return p1Skill > p2Skill;
    }
    return p1.rollValue < p2.rollValue;
  }

  static String resultToText(RollResult r) {
    switch (r) {
      case RollResult.criticalFailure:
        return "KRYTYCZNA PORAŻKA";
      case RollResult.failure:
        return "PORAŻKA";
      case RollResult.success:
        return "NORMALNY SUKCES";
      case RollResult.hardSuccess:
        return "TRUDNY SUKCES";
      case RollResult.extremeSuccess:
        return "EKSTREMALNY SUKCES";
      case RollResult.criticalSuccess:
        return "KRYTYCZNY SUKCES";
    }
  }
}
