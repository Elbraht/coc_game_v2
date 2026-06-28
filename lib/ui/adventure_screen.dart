import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:coc_game_v2/adventure/first_adventure.dart';
import 'package:coc_game_v2/adventure/adventure_engine.dart';
import 'package:coc_game_v2/adventure/adventure_node.dart';
import 'package:coc_game_v2/game_state.dart';
import 'package:coc_game_v2/ui/widgets/character_hud.dart';
import 'package:coc_game_v2/ui/widgets/character_side_panel.dart';
import 'package:coc_game_v2/ui/widgets/test_hud.dart';

class AdventureScreen extends StatefulWidget {
  const AdventureScreen({super.key});

  @override
  State<AdventureScreen> createState() => _AdventureScreenState();
}

class _AdventureScreenState extends State<AdventureScreen> {
  final FirstAdventure adventure = FirstAdventure();
  final AdventureEngine engine = AdventureEngine();

  int index = 0;

  String? skill;
  int? roll;
  int? target;
  String? result;
  int? skillValue;

  bool isResolving = false;
  bool testPerformed = false;

  void runTest(AdventureNode node) {
    final c = GameState.character.value;
    if (c == null) {
      if (kDebugMode) print("🔴 CHARACTER NULL");
      return;
    }

    if (node.skill == null) return;

    // Pobieramy wartość cechy/umiejętności (szukamy w skills, jeśli brak to sprawdzamy statystyki postaci)
    int value = 0;
    if (node.skill == "S") {
      value = c.S;
    } else if (node.skill == "ZR") {
      value = c.ZR;
    } else if (node.skill == "INT") {
      value = c.INT;
    } else if (node.skill == "MOC") {
      value = c.MOC;
    } else if (node.skill == "KON") {
      value = c.KON;
    } else {
      value = c.skills[node.skill] ?? 0;
    }

    final r = engine.runTest(
      skill: value,
      modifier: node.modifier,
    );

    setState(() {
      skill = node.skill;
      roll = r.roll;
      target = r.target;
      result = r.result;
      skillValue = value;
      testPerformed = true;
    });

    // Nakładamy efekty z węzła w zależności od wyniku kości
    if (r.result == "SUCCESS") {
      for (final effect in node.onSuccess) {
        c.applyEffect(effect);
      }
    } else {
      for (final effect in node.onFail) {
        c.applyEffect(effect);
      }
    }
    GameState.refreshHUD();
  }

  void handleChoice(bool isSuccess, AdventureNode node) {
    setState(() {
      if (isSuccess) {
        index = node.successNext ?? index;
      } else {
        index = node.failNext ?? index;
      }
      // Reset stanu testu dla nowego węzła
      skill = null;
      roll = null;
      target = null;
      result = null;
      skillValue = null;
      isResolving = false;
      testPerformed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Bezpieczne pobranie węzła
    final node = (index >= 0 && index < adventure.nodes.length)
        ? adventure.nodes[index]
        : adventure.nodes[0];

    final hasSkillTest = node.skill != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Przygoda"),
      ),
      drawer: const CharacterSidePanel(),
      bottomNavigationBar: const SafeArea(
        child: CharacterHud(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(node.text, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            if (testPerformed && skill != null)
              TestHud(
                skill: skill!,
                skillValue: skillValue ?? 0,
                roll: roll ?? 0,
                target: target ?? 0,
                result: result ?? "FAIL",
              ),
            const Spacer(),
            if (node.isEnd)
              ElevatedButton(
                onPressed: () => setState(() => index = 0),
                child: const Text("KONIEC — restart"),
              )
            else if (hasSkillTest && !testPerformed)
              ElevatedButton(
                onPressed: () => runTest(node),
                child: Text(
                    "Wykonaj test: ${node.skill} (${node.modifier >= 0 ? '+' : ''}${node.modifier})"),
              )
            else if (hasSkillTest && testPerformed) ...[
              ElevatedButton(
                onPressed: () => handleChoice(result == "SUCCESS", node),
                child: Text(result == "SUCCESS"
                    ? "Przejdź dalej (Sukces)"
                    : "Przejdź dalej (Porażka)"),
              ),
            ] else ...[
              ElevatedButton(
                onPressed: () => handleChoice(true, node),
                child: const Text("Dalej"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
