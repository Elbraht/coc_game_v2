import 'dart:math';
import 'package:coc_game_v2/game_state.dart';

class AdventureEffect {
  final String stat;
  final int value;
  final String? dice;

  const AdventureEffect(this.stat, this.value, {this.dice});

  static int resolveEffect(AdventureEffect effect) {
    if (effect.dice != null) {
      return -rollDice(effect.dice!);
    }
    return effect.value;
  }

  static int rollDice(String diceStr) {
    if (diceStr == "0") {
      return 0;
    }
    final parts = diceStr.toLowerCase().split('k');
    int count = int.parse(parts[0]);
    int sides = int.parse(parts[1]);
    int total = 0;
    for (int i = 0; i < count; i++) {
      total += Random().nextInt(sides) + 1;
    }
    return total;
  }

  static Map<String, int> applyEffects(List<AdventureEffect> effects) {
    final c = GameState.character.value;
    Map<String, int> results = {"hp": 0, "san": 0};
    if (c == null) {
      return results;
    }

    for (var effect in effects) {
      int amount = resolveEffect(effect);
      if (effect.stat.toLowerCase() == "hp") {
        c.hpCurrent += amount;
        results["hp"] = results["hp"]! + amount;
        if (c.hpCurrent < 0) {
          c.hpCurrent = 0;
        }
      } else if (effect.stat.toLowerCase() == "san") {
        c.sanCurrent += amount;
        results["san"] = results["san"]! + amount;
        if (c.sanCurrent < 0) {
          c.sanCurrent = 0;
        }
      }
    }
    return results;
  }
}
