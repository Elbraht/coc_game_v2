// ignore_for_file: non_constant_identifier_names

class Character {
  final String name;
  final int age;
  final String gender;
  final String birthPlace;

  final int S;
  final int KON;
  final int BC;
  final int ZR;
  final int INT;
  final int MOC;
  final int WYK;
  final int WYG;

  int HP_MAX;
  int HP_CURRENT;
  int SAN_MAX;
  int SAN_CURRENT;

  final int RUCH;
  final int KRZEPA;
  final int SZCZESCIE;

  final Map<String, int> skills;

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

  void applyEffect(dynamic effect) {
    if (effect.type == 'hp') {
      HP_CURRENT = (HP_CURRENT + effect.value as int).clamp(0, HP_MAX);
    } else if (effect.type == 'san') {
      SAN_CURRENT = (SAN_CURRENT + effect.value as int).clamp(0, SAN_MAX);
    } else if (effect.type == 'skill') {
      final skillName = effect.target as String;
      if (skills.containsKey(skillName)) {
        skills[skillName] =
            (skills[skillName]! + effect.value as int).clamp(1, 99);
      }
    }
  }
}
