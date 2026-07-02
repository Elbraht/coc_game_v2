class NpcAttack {
  final String name; // np. "Szpony", "Ugryzienie"
  final String damageExpression; // np. "1k6", "1k4"
  final int skillValue; // Wartość procentowa trafienia, np. 50 (50%)
  final bool appliesNpcDamageBonus; // Czy ten atak dodaje MO potwora?

  NpcAttack({
    required this.name,
    required this.damageExpression,
    required this.skillValue,
    this.appliesNpcDamageBonus = true,
  });
}

class NPC {
  final String id;
  final String name;
  int hpMax;
  int hpCurrent;
  int sanMax; // Potrzebne, jeśli potwór też może oszaleć lub tracić punkty
  int sanCurrent;
  final int zr; // Kluczowe do kolejności inicjatywy (ZR)
  int mpMax; // Punkty magii (na przyszłość)
  int mpCurrent;
  final String modyfikatorObrazen; // np. "0", "+1k4", "+1k6"
  final int unik; // Wartość procentowa uniku NPC, np. 30 (30%)
  final String
      sanLossExpression; // Utrata poczytalności, np. "0/1k3" lub "1/1k6"

  // Lista unikalnych ataków potwora (pazury psa to nie szpony Cthulhu)
  final List<NpcAttack> attacks;

  // Identyfikatory przedmiotów/broni z baz, które wypadną po śmierci
  final List<String> dropItems;
  final List<String> dropWeapons;

  NPC({
    required this.id,
    required this.name,
    required this.hpMax,
    required this.zr,
    required this.modyfikatorObrazen,
    required this.unik,
    required this.sanLossExpression,
    required this.attacks,
    this.sanMax = 0,
    this.mpMax = 0,
    this.dropItems = const [],
    this.dropWeapons = const [],
  })  : hpCurrent = hpMax,
        sanCurrent = sanMax,
        mpCurrent = mpMax;
}
