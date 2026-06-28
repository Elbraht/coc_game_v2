import 'package:flutter/material.dart';
import '../save/save_system.dart';
import '../save/saved_character.dart';
import 'package:coc_game_v2/game_state.dart';
import 'character_creation_flow.dart';
import 'adventure_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  List<SavedCharacter?> slots = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadSlots();
  }

  Future<void> loadSlots() async {
    final data = await SaveSystem.loadAll();

    if (!mounted) return;

    setState(() {
      slots = data;
      loading = false;
    });
  }

  void startSlot(SavedCharacter c) {
    final character = c.toCharacter();

    debugPrint("🟢 START SLOT");
    debugPrint("-> ${character.name}");

    GameState.setCharacter(character);

    debugPrint("🟢 AFTER SET");
    debugPrint("-> ${GameState.character.value?.name}");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AdventureScreen()),
    );
  }

  void newGame(int slot) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CharacterCreationFlow(slot: slot),
      ),
    ).then((_) {
      if (mounted) loadSlots();
    });
  }

  Widget slotCard(int index) {
    final slot = slots.length > index ? slots[index] : null;

    if (slot == null) {
      return Card(
        child: ListTile(
          title: Text("Slot ${index + 1} (pusty)"),
          trailing: ElevatedButton(
            onPressed: () => newGame(index + 1),
            child: const Text("Nowa postać"),
          ),
        ),
      );
    }

    return Card(
      child: ListTile(
        title: Text("${slot.name} (${slot.age})"),
        subtitle: Text("Slot ${index + 1}"),
        leading: const Icon(Icons.person),
        trailing: ElevatedButton(
          onPressed: () => startSlot(slot),
          child: const Text("Graj"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("COC GAME V2", style: TextStyle(fontSize: 28)),
                const SizedBox(height: 20),
                ...List.generate(3, (i) => slotCard(i)),
                const SizedBox(height: 20),
              ],
            ),
    );
  }
}
