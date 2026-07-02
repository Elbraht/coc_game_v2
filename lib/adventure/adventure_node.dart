import 'package:coc_game_v2/core/adventure_effect.dart';

enum Difficulty { normal, hard, extreme }

class Choice {
  final String text;
  final int targetId;
  final int? failId;
  final String? skill;
  final Difficulty difficulty;
  final int bonusDice;
  final List<AdventureEffect> effects;
  final String? opponentKey;

  // NOWE POLA
  final String? requiredItem;
  final String? requiredClue;

  final String? gainItem;
  final String? gainWeapon;
  final String? gainSpell;
  final String? gainClue;
  final String? dropItem;

  Choice({
    required this.text,
    required this.targetId,
    this.failId,
    this.skill,
    this.difficulty = Difficulty.normal,
    this.bonusDice = 0,
    this.effects = const [],
    this.opponentKey,
    this.requiredItem,
    this.requiredClue,
    this.gainItem,
    this.gainWeapon,
    this.gainSpell,
    this.gainClue,
    this.dropItem,
  });
}

class AdventureNode {
  final int id;
  final String text;
  final List<Choice> choices;
  final List<AdventureEffect> effects;
  final bool isEnd;

  AdventureNode({
    required this.id,
    required this.text,
    this.choices = const [],
    this.effects = const [],
    this.isEnd = false,
  });
}
