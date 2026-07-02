import 'package:coc_game_v2/models/inventory_models.dart';

class InventoryDatabase {
  static final Map<String, GameItem> items = {
    "mosiezny_klucz": GeneralItem(
      name: "Mosiężny Klucz",
      description: "Stary, ciężki klucz pasujący do okutej żelazem skrzyni.",
      weight: 0.1,
      value: 1,
    ),
    "zloty_posag": GeneralItem(
      name: "Złoty Posąg",
      description:
          "Niezwykle ciężka, lita statuetka przedstawiająca bluźnierczą istotę.",
      weight: 25.0,
      value: 500,
    ),
    "apteczka": GeneralItem(
      name: "Apteczka",
      description:
          "Pudełko z bandażami i medykamentami. Zwraca część utraconych HP.",
      weight: 1.5,
      value: 15,
    ),
    "amunicja_38": Ammunition(
      name: "Amunicja .38",
      description: "Pudełko nabojów kalibru .38.",
      weight: 0.5,
      value: 5,
      caliber: ".38",
      count: 12,
    ),
  };

  // Pozostałe puste mapy dla zachowania spójności typów
  static final Map<String, dynamic> spells = {};
  static final Map<String, dynamic> clues = {};
}
