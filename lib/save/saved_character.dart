import '../character.dart';

class SavedCharacter {
  final String name;
  final int age;
  final String gender;
  final String birthPlace;
  final Map<String, int> stats;
  final Map<String, int> umiejetnosci;

  SavedCharacter({
    required this.name,
    required this.age,
    required this.gender,
    required this.birthPlace,
    required this.stats,
    required this.umiejetnosci,
  });

  Character toCharacter() {
    final hpMax = ((stats["S"] ?? 0) + (stats["KON"] ?? 0)) ~/ 10;
    final sanMax = stats["MOC"] ?? 0;
    return Character(
      name: name,
      age: age,
      gender: gender,
      birthPlace: birthPlace,
      S: stats["S"] ?? 0,
      KON: stats["KON"] ?? 0,
      BC: stats["BC"] ?? 0,
      ZR: stats["ZR"] ?? 0,
      INT: stats["INT"] ?? 0,
      MOC: stats["MOC"] ?? 0,
      WYK: stats["WYK"] ?? 0,
      WYG: stats["WYG"] ?? 0,
      HP_MAX: hpMax,
      HP_CURRENT: hpMax,
      SAN_MAX: sanMax,
      SAN_CURRENT: sanMax,
      RUCH: 8,
      KRZEPA: 0,
      SZCZESCIE: 0,
      umiejetnosci: umiejetnosci,
    );
  }

  factory SavedCharacter.fromCharacter(Character c) {
    return SavedCharacter(
      name: c.name,
      age: c.age,
      gender: c.gender,
      birthPlace: c.birthPlace,
      stats: {
        "S": c.S,
        "KON": c.KON,
        "BC": c.BC,
        "ZR": c.ZR,
        "INT": c.INT,
        "MOC": c.MOC,
        "WYK": c.WYK,
        "WYG": c.WYG
      },
      umiejetnosci: c.umiejetnosci,
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "age": age,
        "gender": gender,
        "birthPlace": birthPlace,
        "stats": stats,
        "umiejetnosci": umiejetnosci
      };

  factory SavedCharacter.fromJson(Map<String, dynamic> json) {
    return SavedCharacter(
      name: json["name"],
      age: json["age"],
      gender: json["gender"],
      birthPlace: json["birthPlace"],
      stats: Map<String, int>.from(json["stats"]),
      umiejetnosci: Map<String, int>.from(json["umiejetnosci"]),
    );
  }
}
