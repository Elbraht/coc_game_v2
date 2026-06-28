import 'package:coc_game_v2/game_state.dart';
import 'package:coc_game_v2/adventure/first_adventure.dart';
import 'package:coc_game_v2/core/adventure_effect.dart';

class AdventureExecution {
  final FirstAdventure adventure;

  int currentIndex = 0;

  AdventureExecution(this.adventure);

  AdventureNode get currentNode => adventure.getNode(currentIndex);

  void chooseSuccess() {
    _applyEffects(currentNode.successEffects);
    currentIndex = currentNode.successNext ?? currentIndex;
  }

  void chooseFail() {
    _applyEffects(currentNode.failEffects);
    currentIndex = currentNode.failNext ?? currentIndex;
  }

  void _applyEffects(List<AdventureEffect> effects) {
    final c = GameState.character.value;
    if (c == null) return;

    for (final e in effects) {
      c.applyEffect(e);
    }
  }

  bool get isFinished => currentNode.isEnd;
}
