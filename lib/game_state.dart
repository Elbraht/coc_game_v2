// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
import 'package:flutter/material.dart';
import 'package:coc_game_v2/character.dart';

class GameState {
  static final ValueNotifier<Character?> character =
      ValueNotifier<Character?>(null);

  static void setCharacter(Character c) {
    character.value = c;
    refreshHUD();
  }

  static void refreshHUD() {
    character.notifyListeners();
  }
}
