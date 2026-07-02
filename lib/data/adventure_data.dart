import 'package:coc_game_v2/adventure/adventure_node.dart';

final Map<String, AdventureNode> adventureDataMap = {
  "test_start": AdventureNode(
    id: 0,
    text:
        "Budzisz się w zimnym, zakurzonym gabinecie rezydencji. Na biurku leży stary mosiężny klucz, a w kącie pokoju stoi potężna, okuta żelazem skrzynia. Pod ścianą zauważasz coś błyszczącego – to masywny złoty posąg, który waży aż 25kg.",
    choices: [
      Choice(
        text: "Podnieś Złoty Posąg (Test udźwigu i przeciążenia)",
        gainItem: "zloty_posag",
        targetId: 1,
        failId: 0,
        difficulty: Difficulty.normal,
        bonusDice: 0,
        effects: [],
      ),
      Choice(
        text: "Podnieś Mosiężny Klucz",
        gainItem: "mosiezny_klucz",
        targetId: 2,
        failId: 0,
        difficulty: Difficulty.normal,
        bonusDice: 0,
        effects: [],
      ),
      Choice(
        text: "Spróbuj otworzyć skrzynię",
        requiredItem: "Mosiężny Klucz",
        targetId: 4,
        failId: 0,
        difficulty: Difficulty.normal,
        bonusDice: 0,
        effects: [],
      ),
    ],
  ),
  "test_posag_podniesiony": AdventureNode(
    id: 1,
    text:
        "Z dużym wysiłkiem pakujesz złoty posąg do plecaka. Twój ekwipunek jest teraz niezwykle ciężki (25 kg)! Ponieważ waga ta drastycznie przekracza udźwig (S / 2), silnik gry w tej samej sekundzie wykryje stan 'isOverburdened' i zablokuje możliwość dalszego przechodzenia do innych węzłów, wymuszając wejście do ekwipunku.",
    choices: [
      Choice(
        text: "Porzuć posąg, by odciążyć ekwipunek (Test usuwania)",
        dropItem: "Złoty Posąg",
        targetId: 0,
        failId: 0,
        difficulty: Difficulty.normal,
        bonusDice: 0,
        effects: [],
      ),
    ],
  ),
  "test_klucz_podniesiony": AdventureNode(
    id: 2,
    text:
        "Wsuwasz klucz do kieszeni. Pojawił się w lewym panelu ekwipunku. Możesz teraz zbliżyć się do zamkniętej skrzyni.",
    choices: [
      Choice(
        text: "Użyj klucza na zamku skrzyni (Wykorzystanie przedmiotu)",
        requiredItem: "Mosiężny Klucz",
        targetId: 4,
        failId: 0,
        difficulty: Difficulty.normal,
        bonusDice: 0,
        effects: [],
      ),
    ],
  ),
  "test_otwarcie_skrzyni": AdventureNode(
    id: 4,
    text:
        "Zamek klika i wieko odskakuje. Wewnątrz leży naładowany rewolwer! Gdy go podnosisz, na korytarzu rozlega się skrzypienie drzwi – to Masywny Strażnik idzie sprawdzić hałas. Musisz szybko rzucić na Ukrywanie!",
    choices: [
      Choice(
        text: "Spróbuj skryć się za zasłoną (Test: Ukrywanie)",
        skill: "Ukrywanie",
        gainWeapon: "rewolwer_38",
        targetId: 5,
        failId: 6,
        difficulty: Difficulty.normal,
        bonusDice: 0,
        effects: [],
      ),
    ],
  ),
  "test_ominiecie_straznika": AdventureNode(
    id: 5,
    text:
        "Strażnik rozgląda się po gabinecie, ale twój test Ukrywania okazał się wygrany! Przeciwnik mija cię i odchodzi. Wychodzisz na korytarz, gdzie czeka coś gorszego...",
    choices: [
      Choice(
        text: "Idź dalej przed siebie",
        targetId: 7,
        failId: 7,
        difficulty: Difficulty.normal,
        bonusDice: 0,
        effects: [],
      ),
    ],
  ),
  "test_walka_straznik": AdventureNode(
    id: 6,
    text:
        "Strażnik dostrzega cię w świetle księżyca! Unosi ciężką pałkę i rzuca się do ataku.",
    choices: [
      Choice(
        text: "Rozpocznij Walkę!",
        targetId: 7,
        failId: 99,
        difficulty: Difficulty.normal,
        bonusDice: 0,
        effects: [],
      ),
    ],
  ),
  "test_ogar_spotkanie": AdventureNode(
    id: 7,
    text:
        "Nagle z cienia korytarza wyłania się rycząca, bezkształtna bestia – Ogar Rezydencji. Sama obecność tego potwora rozrywa twój umysł.",
    choices: [
      Choice(
        text: "Walcz o przetrwanie z potworem!",
        targetId: 8,
        failId: 99,
        difficulty: Difficulty.normal,
        bonusDice: 0,
        effects: [],
      ),
    ],
  ),
  "test_wygrana": AdventureNode(
    id: 8,
    text:
        "Ogar pada martwy, a jego ciało obraca się w pył. Widzisz, jak upuszcza przydatne zasoby. Poligon doświadczalny zakończony sukcesem!",
    isEnd: true,
    choices: [],
  ),
  "99": AdventureNode(
    id: 99,
    text:
        "Twoje punkty życia spadły do zera lub utraciłeś całą Poczytalność na widok koszmaru. Padasz bezwładnie na zimną posadzkę rezydencji...",
    isEnd: true,
    choices: [],
  ),
};

// Zapewniamy jawną i widoczną dla innych plików listę węzłów
final List<AdventureNode> adventureData = adventureDataMap.values.toList();
