import 'package:coc_game_v2/adventure/adventure_node.dart';
import 'package:coc_game_v2/core/adventure_effect.dart';

class AdventureData {
  static final List<AdventureNode> nodes = [
    AdventureNode(id: 0, text: "Stoisz przed bramą posiadłości.", choices: [
      Choice(text: "Wejdź głównym wejściem", targetId: 1),
      Choice(
          text: "Skradaj się przez okno",
          targetId: 2,
          skill: "Ukrywanie",
          difficulty: "Regular")
    ]),
    AdventureNode(id: 1, text: "Hol jest mroczny. Słyszysz kroki.", choices: [
      Choice(text: "Krzyknij 'kto tam?'", targetId: 10),
      Choice(
          text: "Schowaj się za posągiem",
          targetId: 11,
          skill: "Ukrywanie",
          difficulty: "Hard")
    ]),
    // ... tutaj dodajesz kolejne paragrafy do id: 74
  ];
}
