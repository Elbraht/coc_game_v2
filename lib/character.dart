import 'core/adventure_effect.dart';

class Character {
  String name;
  int age;
  String gender;
  String birthPlace;

  int S;
  int KON;
  int BC;
  int ZR;
  int INT;
  int MOC;
  int WYK;
  int WYG;

  int HP_MAX;
  int HP_CURRENT;

  int SAN_MAX;
  int SAN_CURRENT;

  int RUCH;
  int KRZEPA;
  int SZCZESCIE;

  Map<String, int> skills;

  Character({
    required this.name,
    required this.age,
    required this.gender,
    required this.birthPlace,
    required this.S,
    required this.KON,
    required this.BC,
    required this.ZR,
    required this.INT,
    required this.MOC,
    required this.WYK,
    required this.WYG,
    required this.HP_MAX,
    required this.HP_CURRENT,
    required this.SAN_MAX,
    required this.SAN_CURRENT,
    required this.RUCH,
    required this.KRZEPA,
    required this.SZCZESCIE,
    required this.skills,
  });

  // =========================
  // CORE EFFECT SYSTEM (COC ENGINE)
  // =========================

  void applyEffect(AdventureEffect e) {
    print("🧬 applyEffect() START");
    print("type: ${e.type}");
    print("value: ${e.value}");
    print("skillName: ${e.skillName}");

    print("BEFORE -> HP: $HP_CURRENT/$HP_MAX, SAN: $SAN_CURRENT/$SAN_MAX");

    switch (e.type) {
      case EffectType.hp:
        HP_CURRENT = (HP_CURRENT + e.value).clamp(0, HP_MAX);
        break;

      case EffectType.san:
        SAN_CURRENT = (SAN_CURRENT + e.value).clamp(0, SAN_MAX);
        break;

      case EffectType.skill:
        skills[e.skillName!] = (skills[e.skillName!] ?? 0) + e.value;
        break;
    }

    print("AFTER  -> HP: $HP_CURRENT/$HP_MAX, SAN: $SAN_CURRENT/$SAN_MAX");
    print("🧬 applyEffect() END");
  }

  // =========================
  // HELPERS (UNCHANGED LOGIC)
  // =========================

  void takeDamage(int value) {
    print("⚔️ takeDamage($value)");
    HP_CURRENT = (HP_CURRENT - value).clamp(0, HP_MAX);
  }

  void heal(int value) {
    print("💚 heal($value)");
    HP_CURRENT = (HP_CURRENT + value).clamp(0, HP_MAX);
  }

  void loseSan(int value) {
    print("🧠 loseSan($value)");
    SAN_CURRENT = (SAN_CURRENT - value).clamp(0, SAN_MAX);
  }

  void gainSan(int value) {
    print("✨ gainSan($value)");
    SAN_CURRENT = (SAN_CURRENT + value).clamp(0, SAN_MAX);
  }
}