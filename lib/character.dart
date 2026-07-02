import 'package:coc_game_v2/models/inventory_models.dart';

class Character {
  final String name;
  final int age;
  final String gender;
  final String birthPlace;

  // Główne cechy postaci
  int s;
  int kon;
  int bc;
  int zr;
  int inte;
  int moc;
  int wyk;
  int wyg;

  // Statystyki bieżące i maksymalne
  int hpMax;
  int hpCurrent;
  int sanMax;
  int sanCurrent;
  int ruch;
  int szczescie;

  // Ekwipunek i listy
  List<GameItem> items = [];
  List<Weapon> weapons = [];
  List<Spell> spells = [];
  List<Clue> clues = [];

  // Mapa wszystkich umiejętności postaci
  Map<String, int> umiejetnosci;

  Character({
    required this.name,
    required this.age,
    required this.gender,
    required this.birthPlace,
    required this.s,
    required this.kon,
    required this.bc,
    required this.zr,
    required this.inte,
    required this.moc,
    required this.wyk,
    required this.wyg,
    required this.hpMax,
    required this.hpCurrent,
    required this.sanMax,
    required this.sanCurrent,
    required this.ruch,
    required this.szczescie,
    required this.umiejetnosci,
    int? krzepa, // Stary parametr ignorujemy, bo mamy getter
  });

  // Pomocnicza metoda używana w AdventureScreen do pobierania cechy lub umiejętności
  int getStatOrSkill(String name) {
    String lower = name.toLowerCase();
    if (lower == "s") return s;
    if (lower == "kon") return kon;
    if (lower == "bc") return bc;
    if (lower == "zr") return zr;
    if (lower == "int" || lower == "inte") return inte;
    if (lower == "moc") return moc;
    if (lower == "wyk") return wyk;
    if (lower == "wyg") return wyg;

    // Jeśli to nie cecha, szukamy w mapie umiejętności
    return umiejetnosci[name] ?? 0;
  }

  // Obliczanie udźwigu dla InventorySidePanel
  double get currentWeight {
    double total = 0;
    for (var item in items) {
      total += item.weight;
    }
    for (var weapon in weapons) {
      total += weapon.weight;
    }
    return total;
  }

  bool get isOverburdened => currentWeight > (s / 2);

  // Dynamiczny getter dla Modyfikatora Obrażeń (MO)
  String get modyfikatorObrazen {
    int sum = s + bc;
    if (sum <= 64) return "-2";
    if (sum <= 84) return "-1";
    if (sum <= 124) return "0";
    if (sum <= 164) return "+1k4";
    int n = 1 + ((sum - 125) ~/ 80);
    return "+${n}k6";
  }

  // Dynamiczny getter dla Krzepy
  int get krzepa {
    int sum = s + bc;
    if (sum <= 64) return -2;
    if (sum <= 84) return -1;
    if (sum <= 124) return 0;
    if (sum <= 164) return 1;
    return 1 + ((sum - 125) ~/ 80);
  }
}
