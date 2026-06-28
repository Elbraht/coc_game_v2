import 'package:coc_game_v2/core/adventure_effect.dart';

class AdventureNode {
  final int id;
  final String text;
  final List<Choice> choices;
  final bool isEnd;

  AdventureNode({
    required this.id,
    required this.text,
    this.choices = const [],
    this.isEnd = false,
  });
}

class Choice {
  final String text;
  final int targetId;
  final String? skill;
  final String difficulty; // "Regular", "Hard", "Extreme"
  final List<AdventureEffect> effects;

  Choice({
    required this.text,
    required this.targetId,
    this.skill,
    this.difficulty = "Regular",
    this.effects = const [],
  });
}
