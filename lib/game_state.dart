import 'package:flutter/foundation.dart';
import 'character.dart';

class GameState {
  static final ValueNotifier<Character?> character =
      ValueNotifier<Character?>(null);

  static final ValueNotifier<int> hudTick = ValueNotifier(0);

  static void refreshHUD() {
    hudTick.value++;

    debugPrint("🟡 refreshHUD()");
    debugPrint("-> character null: ${character.value == null}");

    character.notifyListeners();
  }

  static void setCharacter(Character c) {
    character.value = c;

    debugPrint("🟢 setCharacter: ${c.name}");

    refreshHUD();
  }

  static void updateCharacter(Character updated) {
    character.value = updated;

    debugPrint("🔵 updateCharacter");

    refreshHUD();
  }
}