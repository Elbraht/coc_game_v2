import 'package:flutter/material.dart';
import '../save/save_system.dart';
import '../save/saved_character.dart';
import 'package:coc_game_v2/game_state.dart';
import 'package:coc_game_v2/ui/character_creation_flow.dart';
import 'adventure_screen.dart';
import '../data/adventure_data.dart';

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
    GameState.setCharacter(c.toCharacter());
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) =>
                AdventureScreen(adventureData: AdventureData.nodes)));
  }

  void newGame(int slot) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => CharacterCreationFlow(slot: slot))).then((_) {
      if (mounted) loadSlots();
    });
  }

  Widget slotCard(int index) {
    final slot = slots.length > index ? slots[index] : null;
    return Card(
        child: ListTile(
      title: Text(slot == null ? "Slot ${index + 1} (pusty)" : "${slot.name}"),
      trailing: ElevatedButton(
        onPressed: () => slot == null ? newGame(index + 1) : startSlot(slot),
        child: Text(slot == null ? "Nowa" : "Graj"),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : Column(children: [
                const SizedBox(height: 50),
                ...List.generate(3, (i) => slotCard(i))
              ]));
  }
}
