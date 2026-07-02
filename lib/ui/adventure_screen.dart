import 'package:flutter/material.dart';
import 'package:coc_game_v2/adventure/adventure_node.dart';
import 'package:coc_game_v2/data/inventory_database.dart';
import 'package:coc_game_v2/data/weapons_database.dart';
import 'package:coc_game_v2/data/npc_data.dart';
import 'package:coc_game_v2/ui/combat_screen.dart';
import 'package:coc_game_v2/ui/widgets/character_hud.dart';
import 'package:coc_game_v2/ui/widgets/character_side_panel.dart';
import 'package:coc_game_v2/ui/widgets/inventory_side_panel.dart';
import 'package:coc_game_v2/game_state.dart';

class AdventureScreen extends StatefulWidget {
  final List<AdventureNode> adventureData;
  const AdventureScreen({super.key, required this.adventureData});

  @override
  State<AdventureScreen> createState() => _AdventureScreenState();
}

class _AdventureScreenState extends State<AdventureScreen> {
  int currentNodeId = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Set<String> _collectedGainsKeys = {};

  String _getChoiceKey(Choice choice) {
    return "${currentNodeId}_${choice.text}";
  }

  void _processInventoryGains(Choice choice) {
    final c = GameState.character.value;
    if (c == null) return;

    if (choice.gainItem != null) {
      // Inteligentne przeszukiwanie baz danych
      var weaponBase = WeaponsDatabase.list[choice.gainItem];
      if (weaponBase != null) {
        if (!c.weapons.any((w) => w.name == weaponBase.name)) {
          c.weapons.add(weaponBase);
        }
      } else {
        var itemBase = InventoryDatabase.items[choice.gainItem];
        if (itemBase != null) c.items.add(itemBase);
      }
    }

    if (choice.gainSpell != null) {
      var s = InventoryDatabase.spells[choice.gainSpell];
      if (s != null) c.spells.add(s);
    }
    if (choice.gainClue != null) {
      var cl = InventoryDatabase.clues[choice.gainClue];
      if (cl != null) c.clues.add(cl);
    }
    _collectedGainsKeys.add(_getChoiceKey(choice));
    GameState.refreshHUD();
  }

  void _startInteractiveCombat(String npcId, Choice choice) async {
    final player = GameState.character.value;
    if (player == null) return;
    final enemyClone = NpcDatabase.getClone(npcId);

    bool combatWon = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => CombatScreen(player: player, enemy: enemyClone)),
        ) ??
        false;

    if (combatWon && player.hpCurrent > 0 && player.sanCurrent > 0) {
      _processInventoryGains(choice);
      setState(() => currentNodeId = choice.targetId);
    } else {
      setState(() => currentNodeId = 99);
    }
    GameState.refreshHUD();
  }

  void _makeChoice(Choice choice) {
    if (choice.targetId == 6 || choice.targetId == 7) {
      _startInteractiveCombat("straznik", choice);
      return;
    }
    if (choice.targetId == 8 && currentNodeId == 7) {
      _startInteractiveCombat("ogar", choice);
      return;
    }

    _processInventoryGains(choice);
    setState(() => currentNodeId = choice.targetId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(children: [
            TextButton(
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                child: const Text("Ekwipunek",
                    style: TextStyle(color: Colors.amber))),
            const Spacer(),
            TextButton(
                onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                child: const Text("Umiejętności",
                    style: TextStyle(color: Colors.amber))),
          ]),
          bottom: const PreferredSize(
              preferredSize: Size.fromHeight(80), child: CharacterHud())),
      drawer: const InventorySidePanel(),
      endDrawer: const CharacterSidePanel(),
      body: ValueListenableBuilder(
          valueListenable: GameState.character,
          builder: (context, character, _) {
            final node = widget.adventureData.firstWhere(
                (n) => n.id == currentNodeId,
                orElse: () => widget.adventureData[0]);
            return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  Expanded(
                      child: Center(
                          child: Text(node.text,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18)))),
                  ...node.choices.map((c) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3E2723),
                                foregroundColor: Colors.amber),
                            onPressed: () => _makeChoice(c),
                            child: Text(c.text)),
                      ))),
                ]));
          }),
    );
  }
}
