import 'package:coc_game_v2/models/npc_model.dart';

class NpcDatabase {
  static final Map<String, NPC> monsters = {
    "straznik": NPC(
      id: "straznik",
      name: "Masywny Strażnik",
      hpMax: 20,
      zr: 45,
      modyfikatorObrazen: "+1k4",
      unik: 25,
      sanLossExpression: "0/1k3",
      mpMax: 10,
      attacks: [
        NpcAttack(
          name: "Uderzenie ciężką pałką",
          damageExpression: "1k8",
          skillValue: 45,
          appliesNpcDamageBonus: true,
        ),
      ],
      dropWeapons: ["rewolwer_38"], // Gracz zyskuje broń z bazy po wygranej
      dropItems: [],
    ),
    "ogar": NPC(
      id: "ogar",
      name: "Ogar Rezydencji",
      hpMax: 15,
      zr: 65,
      modyfikatorObrazen: "0",
      unik: 35,
      sanLossExpression: "1/1k6", // Zdany: 1 SAN, oblany: rzut 1k6 SAN
      attacks: [
        NpcAttack(
          name: "Kąsanie",
          damageExpression: "1k6",
          skillValue: 50,
          appliesNpcDamageBonus: true,
        ),
      ],
      dropItems: ["apteczka"], // Gracz zyskuje apteczkę z bazy po wygranej
      dropWeapons: [],
    ),
  };

  static NPC getClone(String id) {
    final base = monsters[id];
    if (base == null) throw Exception("Nie znaleziono potwora o ID: $id");

    return NPC(
      id: base.id,
      name: base.name,
      hpMax: base.hpMax,
      zr: base.zr,
      modyfikatorObrazen: base.modyfikatorObrazen,
      unik: base.unik,
      sanLossExpression: base.sanLossExpression,
      sanMax: base.sanMax,
      mpMax: base.mpMax,
      attacks: List.from(base.attacks),
      dropItems: List.from(base.dropItems),
      dropWeapons: List.from(base.dropWeapons),
    );
  }
}
