import 'adventure_node.dart';
import '../core/adventure_effect.dart';

class FirstAdventure {
  final List<AdventureNode> nodes = [];

  FirstAdventure() {
    nodes.addAll([
      AdventureNode(
        text: "Budzisz się w ciemnej piwnicy. Drzwi są zamknięte.",
        skill: "S",
        modifier: -20,
        successNext: 1,
        failNext: 2,
        onSuccess: [
          AdventureEffect.skill("escape", 5),
        ],
        onFail: [
          AdventureEffect.hp(-2),
          AdventureEffect.san(-1),
        ],
      ),
      AdventureNode(
        text: "Drzwi ustępują. Wychodzisz na korytarz.",
        successNext: 3,
        failNext: 3,
      ),
      AdventureNode(
        text: "Panika. Uderzasz w drzwi aż krwawią dłonie.",
        successNext: 3,
        failNext: 3,
        onFail: [
          AdventureEffect.hp(-2),
          AdventureEffect.san(-2),
        ],
      ),
      AdventureNode(
        text: "Na ścianie widzisz skrzynkę elektryczną iskrzącą się.",
        skill: "ELEKTRYKA",
        modifier: -30,
        successNext: 4,
        failNext: 5,
        onSuccess: [
          AdventureEffect.skill("tech", 3),
        ],
        onFail: [
          AdventureEffect.hp(-2),
          AdventureEffect.san(-1),
        ],
      ),
      AdventureNode(
        text: "Prąd wraca. Drzwi się otwierają.",
        successNext: 6,
        failNext: 6,
      ),
      AdventureNode(
        text: "Porażka. Iskra trafia cię w rękę.",
        successNext: 6,
        failNext: 6,
        onFail: [
          AdventureEffect.hp(-3),
        ],
      ),
      AdventureNode(
        text: "Koniec testowej przygody.",
        isEnd: true,
      ),
    ]);
  }

  AdventureNode getNode(int index) => nodes[index];
}
