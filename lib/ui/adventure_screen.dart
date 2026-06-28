import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:coc_game_v2/adventure/first_adventure.dart';
import 'package:coc_game_v2/adventure/adventure_engine.dart';
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

  bool isResolving = false;

  void runTest(node) {
    final c = GameState.character.value;

    if (c == null) {
      if (kDebugMode) print("🔴 CHARACTER NULL");
      return;
    }

    if (node.skill == null) return;

    final skillValue = c.skills[node.skill] ?? 0;

    final r = engine.runTest(
      skill: skillValue,
      modifier: node.modifier,
    );

    setState(() {
      skill = node.skill;
      roll = r.roll;
      target = r.target;
      result = r.result;
    });

    if (kDebugMode) {
      print("🟢 TEST: ${r.result}");
    }
  }

  void go(int next) {
    final c = GameState.character.value;

    if (c == null) {
      if (kDebugMode) print("🔴 GO: CHARACTER NULL");
      return;
    }

    final node = adventure.getNode(index);

    final success = result == "SUCCESS";
    final effects = success ? node.onSuccess : node.onFail;

    for (final e in effects) {
      c.applyEffect(e);
    }

    setState(() {
      index = next;
      skill = null;
      roll = null;
      target = null;
      result = null;
      isResolving = false;
    });

    GameState.refreshHUD();
  }

  void handleChoice(bool successPath, node) {
    if (isResolving) return;

    setState(() {
      isResolving = true;
    });

    runTest(node);

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;

      go(successPath ? node.successNext! : node.failNext!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final node = adventure.getNode(index);

    final hasChoices = node.successNext != null && node.failNext != null;

    return Scaffold(
      appBar: AppBar(title: const Text("Przygoda")),
      drawer: const CharacterSidePanel(),
      bottomNavigationBar: const CharacterHud(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(node.text, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            if (skill != null)
              TestHud(
                skill: skill!,
                skillValue: target ?? 0,
                roll: roll ?? 0,
                target: target ?? 0,
                result: result ?? "",
              ),
            const Spacer(),
            if (node.isEnd)
              ElevatedButton(
                onPressed: () => setState(() => index = 0),
                child: const Text("KONIEC — restart"),
              )
            else if (hasChoices) ...[
              ElevatedButton(
                onPressed: () {
                  handleChoice(true, node);
                },
                child: Text("A — sukces / ${node.skill ?? 'brak'}"),
              ),
              ElevatedButton(
                onPressed: () {
                  handleChoice(false, node);
                },
                child: Text("B — porażka / ${node.skill ?? 'brak'}"),
              ),
            ] else
              ElevatedButton(
                onPressed: () {
                  handleChoice(true, node);
                },
                child: const Text("Dalej"),
              ),
          ],
        ),
      ),
    );
  }
}
