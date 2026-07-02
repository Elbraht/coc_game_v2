import 'package:flutter/material.dart';
import 'package:coc_game_v2/game_state.dart';

class CharacterHud extends StatelessWidget {
  const CharacterHud({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: GameState.character,
        builder: (context, c, __) {
          if (c == null) return const SizedBox.shrink();
          return Container(
              color: Colors.black,
              padding: const EdgeInsets.all(5),
              child: Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("HP:${c.hpCurrent}/${c.hpMax}",
                          style: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold)),
                      Text("SAN:${c.sanCurrent}/${c.sanMax}",
                          style: const TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold)),
                    ]),
                const SizedBox(height: 4),
                Text(
                    "S:${c.s} KON:${c.kon} BC:${c.bc} ZR:${c.zr} INT:${c.inte} MOC:${c.moc}",
                    style: const TextStyle(color: Colors.amber, fontSize: 12)),
                const SizedBox(height: 2),
                // NOWA SEKIDŻA: MO oraz Krzepa pobierane dynamicznie z gettera postaci
                Text("MO: ${c.modyfikatorObrazen}   |   Krzepa: ${c.krzepa}",
                    style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
              ]));
        });
  }
}
