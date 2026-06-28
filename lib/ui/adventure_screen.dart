import 'package:flutter/material.dart';
import 'package:coc_game_v2/game_state.dart';
import 'package:coc_game_v2/character.dart';
import 'package:coc_game_v2/ui/widgets/character_side_panel.dart';
import 'package:coc_game_v2/adventure/adventure_execution.dart';
import 'package:coc_game_v2/adventure/adventure_node.dart';
import 'package:coc_game_v2/core/roll_system.dart';

class AdventureScreen extends StatefulWidget {
  final List<AdventureNode> adventureData;
  const AdventureScreen({super.key, required this.adventureData});

  @override
  State<AdventureScreen> createState() => _AdventureScreenState();
}

class _AdventureScreenState extends State<AdventureScreen> {
  late AdventureExecution execution;
  String logMessage = "Rozpoczynasz śledztwo...";

  @override
  void initState() {
    super.initState();
    execution = AdventureExecution(widget.adventureData);
  }

  void handleChoice(Choice choice) {
    final c = GameState.character.value;
    if (c == null) return;

    // Jeśli wybór wymaga testu
    if (choice.skill != null) {
      final skillValue = c.umiejetnosci[choice.skill!] ?? 0;
      final outcome = RollSystem.test(choice.skill!, skillValue);

      setState(() {
        logMessage =
            "Wynik: ${RollSystem.resultToText(outcome.result)} (${outcome.roll}/${outcome.skill})";

        // Sprawdzenie sukcesu (uwzględniając różne rodzaje sukcesów)
        bool isSuccess = outcome.result == RollResult.success ||
            outcome.result == RollResult.hardSuccess ||
            outcome.result == RollResult.extremeSuccess ||
            outcome.result == RollResult.criticalSuccess;

        if (isSuccess) {
          execution.currentIndex = choice.targetId;
        } else {
          // Opcjonalnie: jeśli oblany test, zostajemy lub idziemy w inne miejsce (tu zostajemy)
          logMessage += " - Nie udało się.";
        }
      });
    } else {
      // Jeśli brak testu, przechodzimy po prostu dalej
      setState(() {
        execution.currentIndex = choice.targetId;
        logMessage = "Wybrano: ${choice.text}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final node = execution.currentNode;
    return Scaffold(
      endDrawer: const CharacterSidePanel(),
      appBar: AppBar(title: const Text("Zew Cthulhu")),
      body: ValueListenableBuilder<Character?>(
        valueListenable: GameState.character,
        builder: (context, c, _) {
          if (c == null) return const Center(child: Text("Brak postaci"));

          return Column(children: [
            Padding(
                padding: const EdgeInsets.all(8),
                child: Text("Log: $logMessage")),
            Padding(padding: const EdgeInsets.all(16), child: Text(node.text)),

            // Generowanie przycisków dla każdej opcji wyboru
            ...node.choices.map((choice) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ElevatedButton(
                    onPressed: () => handleChoice(choice),
                    child: Text(choice.text +
                        (choice.skill != null
                            ? " [Test: ${choice.skill}]"
                            : "")),
                  ),
                )),
          ]);
        },
      ),
    );
  }
}
