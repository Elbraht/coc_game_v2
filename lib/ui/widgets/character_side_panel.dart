import 'package:flutter/material.dart';
import 'package:coc_game_v2/game_state.dart';

class CharacterSidePanel extends StatelessWidget {
  const CharacterSidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ValueListenableBuilder(
        valueListenable: GameState.character,
        builder: (context, character, _) {
          if (character == null) {
            return const Center(child: Text("Brak postaci"));
          }

          final skills = character.skills.entries.toList();

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              const Text("SKILLE",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Divider(),

              ...skills.map((e) => ListTile(
                    title: Text(e.key),
                    trailing: Text("${e.value}%"),
                  )),

              const Divider(),

              const Text("STATYSTYKI",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              Text("S: ${character.S}"),
              Text("KON: ${character.KON}"),
              Text("BC: ${character.BC}"),
              Text("ZR: ${character.ZR}"),
              Text("INT: ${character.INT}"),
              Text("MOC: ${character.MOC}"),
              Text("WYG: ${character.WYG}"),
              Text("WYK: ${character.WYK}"),

              const Divider(),

              Text("HP: ${character.HP_CURRENT}/${character.HP_MAX}"),
              Text("SAN: ${character.SAN_CURRENT}/${character.SAN_MAX}"),
            ],
          );
        },
      ),
    );
  }
}