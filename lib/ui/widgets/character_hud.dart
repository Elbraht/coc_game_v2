import 'package:flutter/material.dart';
import 'package:coc_game_v2/game_state.dart';

class CharacterHud extends StatelessWidget {
  const CharacterHud({super.key});

  @override
  Widget build(BuildContext context) {
    if (true) {
      // ignore: avoid_print
      debugPrint("🟣 HUD BUILD()");
    }

    return ValueListenableBuilder(
      valueListenable: GameState.character,
      builder: (context, c, __) {

        if (true) {
          // ignore: avoid_print
          debugPrint("🟡 HUD LISTENER TRIGGERED");
          // ignore: avoid_print
          debugPrint("   -> character null: ${c == null}");
        }

        if (c == null) {
          return const SizedBox();
        }

        return Container(
          padding: const EdgeInsets.all(10),
          color: Colors.black12,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("HP: ${c.HP_CURRENT}/${c.HP_MAX}"),
                  Text("SAN: ${c.SAN_CURRENT}/${c.SAN_MAX}"),
                ],
              ),

              const SizedBox(height: 6),

              Wrap(
                spacing: 10,
                children: [
                  Text("S: ${c.S}"),
                  Text("KON: ${c.KON}"),
                  Text("ZR: ${c.ZR}"),
                  Text("INT: ${c.INT}"),
                  Text("MOC: ${c.MOC}"),
                  Text("WYK: ${c.WYK}"),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}