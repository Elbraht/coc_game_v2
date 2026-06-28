// ignore_for_file: non_constant_identifier_names
class Character {
  final String name;
  final int age;
  final String gender;
  final String birthPlace;
  final int S, KON, BC, ZR, INT, MOC, WYK, WYG;
  int HP_MAX, HP_CURRENT, SAN_MAX, SAN_CURRENT;
  final int RUCH, KRZEPA, SZCZESCIE;
  final Map<String, int> umiejetnosci;

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
    required this.umiejetnosci,
  });

  // Metoda dodana, aby naprawić błąd w adventure_execution.dart
  void applyEffect(dynamic effect) {}

  Character copyWith({int? HP_CURRENT, int? SAN_CURRENT}) {
    return Character(
      name: name,
      age: age,
      gender: gender,
      birthPlace: birthPlace,
      S: S,
      KON: KON,
      BC: BC,
      ZR: ZR,
      INT: INT,
      MOC: MOC,
      WYK: WYK,
      WYG: WYG,
      HP_MAX: HP_MAX,
      HP_CURRENT: HP_CURRENT ?? this.HP_CURRENT,
      SAN_MAX: SAN_MAX,
      SAN_CURRENT: SAN_CURRENT ?? this.SAN_CURRENT,
      RUCH: RUCH,
      KRZEPA: KRZEPA,
      SZCZESCIE: SZCZESCIE,
      umiejetnosci: umiejetnosci,
    );
  }
}
