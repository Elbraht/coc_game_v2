import 'package:flutter/material.dart';
import 'package:coc_game_v2/game_state.dart';

class CharacterSidePanel extends StatelessWidget {
  const CharacterSidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF2C2621),
      child: ValueListenableBuilder(
        valueListenable: GameState.character,
        builder: (context, c, _) {
          if (c == null) return const SizedBox();
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text("UMIEJĘTNOŚCI",
                  style: TextStyle(
                      color: Colors.amber,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              const Divider(color: Colors.amber),
              const SizedBox(height: 10),
              ...c.umiejetnosci.entries.map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(e.key,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16)),
                        Text("${e.value}%",
                            style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }
}
