import 'package:coc_game_v2/adventure/adventure_node.dart';

class AdventureExecution {
  final List<AdventureNode> nodes;
  int currentIndex = 0;

  AdventureExecution(this.nodes);

  AdventureNode get currentNode =>
      nodes.firstWhere((n) => n.id == currentIndex, orElse: () => nodes[0]);
}
