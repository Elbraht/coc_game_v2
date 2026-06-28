import 'package:flutter/material.dart';
import 'package:coc_game_v2/game_state.dart';

class CharacterSidePanel extends StatelessWidget {
  const CharacterSidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ValueListenableBuilder(
        valueListenable: GameState.character,
        builder: (context, c, _) {
          if (c == null) return const Center(child: Text("Brak postaci"));
          return ListView(padding: const EdgeInsets.all(12), children: [
            const Text("CECHY",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("S: ${c.S} | KON: ${c.KON} | BC: ${c.BC}"),
            Text("ZR: ${c.ZR} | INT: ${c.INT} | MOC: ${c.MOC}"),
            Text("WYG: ${c.WYG} | WYK: ${c.WYK}"),
            Text(
                "RUCH: ${c.RUCH} | KRZEPA: ${c.KRZEPA} | SZCZESCIE: ${c.SZCZESCIE}"),
            const Divider(),
            const Text("UMIEJĘTNOŚCI",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ...c.umiejetnosci.entries.map((e) =>
                ListTile(title: Text(e.key), trailing: Text("${e.value}%"))),
            const Divider(),
            Text("HP: ${c.HP_CURRENT}/${c.HP_MAX}",
                style: const TextStyle(color: Colors.red)),
            Text("SAN: ${c.SAN_CURRENT}/${c.SAN_MAX}",
                style: const TextStyle(color: Colors.purple)),
          ]);
        },
      ),
    );
  }
}
