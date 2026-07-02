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
    final hpMax = ((stats["s"] ?? 0) + (stats["kon"] ?? 0)) ~/ 10;
    final sanMax = stats["moc"] ?? 0;
    return Character(
      name: name,
      age: age,
      gender: gender,
      birthPlace: birthPlace,
      s: stats["s"] ?? 0,
      kon: stats["kon"] ?? 0,
      bc: stats["bc"] ?? 0,
      zr: stats["zr"] ?? 0,
      inte: stats["inte"] ?? 0,
      moc: stats["moc"] ?? 0,
      wyk: stats["wyk"] ?? 0,
      wyg: stats["wyg"] ?? 0,
      hpMax: hpMax,
      hpCurrent: hpMax,
      sanMax: sanMax,
      sanCurrent: sanMax,
      ruch: 8,
      krzepa: 0,
      szczescie: 0,
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
        "s": c.s,
        "kon": c.kon,
        "bc": c.bc,
        "zr": c.zr,
        "inte": c.inte,
        "moc": c.moc,
        "wyk": c.wyk,
        "wyg": c.wyg
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
