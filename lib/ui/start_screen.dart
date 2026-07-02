import 'package:flutter/material.dart';
import 'package:coc_game_v2/ui/adventure_screen.dart';
import 'package:coc_game_v2/ui/character_creation_flow.dart';
import 'package:coc_game_v2/save/save_system.dart';
import 'package:coc_game_v2/data/adventure_data.dart';
import 'package:coc_game_v2/game_state.dart';
import 'package:coc_game_v2/save/saved_character.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  // =========================================================================
  // 🟢 MODAL DLA NOWEJ GRY (Wybór slotu do nadpisania/zapisania)
  // =========================================================================
  void _showNewGameSlotsDialog(BuildContext context) async {
    List<SavedCharacter?> slots = await SaveSystem.loadAll();

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2621),
        title: const Text("WYBIERZ SLOT DLA NOWEJ POSTACI",
            style: TextStyle(color: Colors.amber, fontSize: 18)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (context, index) {
              final slotNumber = index + 1;
              final character = slots[index];

              return Card(
                color: const Color(0xFF1A1A1A),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(
                    "Slot $slotNumber: ${character != null ? character.name : 'Pusty Slot'}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    character != null
                        ? "⚠️ Kliknięcie nadpisze tę postać!"
                        : "Wolne miejsce na zapis",
                    style: TextStyle(
                      color: character != null
                          ? Colors.red.shade300
                          : Colors.green.shade300,
                      fontSize: 12,
                    ),
                  ),
                  trailing: Icon(
                    character != null ? Icons.save : Icons.add_box,
                    color: character != null ? Colors.amber : Colors.green,
                  ),
                  onTap: () {
                    Navigator.pop(context); // Zamyka modal
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CharacterCreationFlow(slot: slotNumber),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ANULUJ", style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // 🔵 MODAL DLA WCZYTANIA GRY (Wybór istniejącej postaci)
  // =========================================================================
  void _showLoadSlotsDialog(BuildContext context) async {
    List<SavedCharacter?> slots = await SaveSystem.loadAll();

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2621),
        title: const Text("WYBIERZ SLOT ZAPISU",
            style: TextStyle(color: Colors.amber)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (context, index) {
              final slotNumber = index + 1;
              final character = slots[index];

              return Card(
                color: const Color(0xFF1A1A1A),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(
                    "Slot $slotNumber: ${character != null ? character.name : 'Pusty Slot'}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: character != null
                      ? Text(
                          "Wiek: ${character.age}, Miejsce: ${character.birthPlace}",
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12))
                      : const Text("Brak zapisanych danych",
                          style:
                              TextStyle(color: Colors.white30, fontSize: 12)),
                  trailing: Icon(
                    character != null ? Icons.file_open : Icons.lock_open,
                    color: character != null ? Colors.amber : Colors.white30,
                  ),
                  onTap: () {
                    if (character != null) {
                      Navigator.pop(context); // Zamyka modal
                      GameState.character.value = character.toCharacter();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AdventureScreen(adventureData: adventureData),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                "Slot $slotNumber jest pusty! Utwórz nową postać.")),
                      );
                    }
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ANULUJ", style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text("Zew Cthulhu", style: TextStyle(color: Colors.amber)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "ZEW CTHULHU",
              style: TextStyle(
                color: Colors.amber,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const Text(
              "Silnik Gry Paragrafowej v2",
              style: TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                  fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 60),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3E2723),
                  foregroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => _showNewGameSlotsDialog(context),
                child: const Text("NOWA GRA",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C2621),
                  foregroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => _showLoadSlotsDialog(context),
                child: const Text("WCZYTAJ GRE",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
