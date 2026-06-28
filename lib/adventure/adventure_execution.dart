import 'package:coc_game_v2/game_state.dart';
import 'package:coc_game_v2/adventure/adventure_node.dart';
import 'package:coc_game_v2/core/adventure_effect.dart';

class AdventureExecution {
  final dynamic adventure; // Elastyczny typ, by pasował do każdej przygody

  int currentIndex = 0;

  AdventureExecution(this.adventure);

  AdventureNode get currentNode => adventure.getNode(currentIndex);

  void chooseSuccess() {
    _applyEffects(currentNode.onSuccess);
    currentIndex = currentNode.successNext ?? currentIndex;
  }

  void chooseFail() {
    _applyEffects(currentNode.onFail);
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
