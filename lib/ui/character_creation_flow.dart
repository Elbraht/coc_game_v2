import 'package:flutter/material.dart';
import 'package:coc_game_v2/game_state.dart';
import 'package:coc_game_v2/character.dart';
import 'dart:math';
import 'package:coc_game_v2/ui/adventure_screen.dart';
import '../save/save_system.dart';
import '../save/saved_character.dart';
import '../data/adventure_data.dart';

// Zmieniliśmy 'base' na zwykłą zmienną (bez 'final'),
// aby móc nadpisywać bazę Uniku po zmianie Zręczności.
class Skill {
  int base;
  int? bonus;
  Skill(this.base, {this.bonus});
  int get finalValue => bonus ?? base;
}

class CharacterCreationFlow extends StatefulWidget {
  final int slot;
  const CharacterCreationFlow({super.key, required this.slot});

  @override
  State<CharacterCreationFlow> createState() => _CharacterCreationFlowState();
}

class _CharacterCreationFlowState extends State<CharacterCreationFlow> {
  int step = 0;
  final Random _rng = Random();
  int d6() => _rng.nextInt(6) + 1;
  late final int szczescie;

  @override
  void initState() {
    super.initState();
    szczescie = (d6() + d6() + d6()) * 5;
  }

  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final birthCtrl = TextEditingController();
  String gender = "M";

  int s = 0, kon = 0, bc = 0, zr = 0, wyg = 0, inte = 0, moc = 0, wyk = 0;
  List<int> statPool = [80, 70, 60, 60, 50, 50, 50, 40];
  final Map<String, int> selectedStats = {};

  void assignStat(String key, int value) {
    setState(() {
      if (!statPool.contains(value)) return;
      if (selectedStats.containsKey(key)) statPool.add(selectedStats[key]!);
      selectedStats[key] = value;
      statPool.remove(value);
      switch (key) {
        case "S":
          s = value;
          break;
        case "KON":
          kon = value;
          break;
        case "BC":
          bc = value;
          break;
        case "ZR":
          zr = value;
          // Unik automatycznie ustawiany na 1/2 ZR
          skills["Unik"]!.base = (zr / 2).floor();
          break;
        case "WYG":
          wyg = value;
          break;
        case "INT":
          inte = value;
          break;
        case "MOC":
          moc = value;
          break;
        case "WYK":
          wyk = value;
          break;
      }
    });
  }

  void resetStat(String key) {
    setState(() {
      if (selectedStats.containsKey(key)) {
        statPool.add(selectedStats[key]!);
        selectedStats.remove(key);
      }
      switch (key) {
        case "S":
          s = 0;
          break;
        case "KON":
          kon = 0;
          break;
        case "BC":
          bc = 0;
          break;
        case "ZR":
          zr = 0;
          skills["Unik"]!.base = 0; // Reset Uniku
          break;
        case "WYG":
          wyg = 0;
          break;
        case "INT":
          inte = 0;
          break;
        case "MOC":
          moc = 0;
          break;
        case "WYK":
          wyk = 0;
          break;
      }
    });
  }

  // Obliczanie Modyfikatora Obrażeń (MO)
  String getModyfikatorObrazen() {
    int sum = s + bc;
    if (sum == 0) return "0";
    if (sum <= 64) return "-2";
    if (sum <= 84) return "-1";
    if (sum <= 124) return "0";
    if (sum <= 164) return "+1k4";
    // Formuła matematyczna pokrywająca +1k6, +2k6, +3k6 itd. (za każde kolejne 80)
    int n = 1 + ((sum - 125) ~/ 80);
    return "+${n}k6";
  }

  // Obliczanie Krzepy
  int getKrzepa() {
    int sum = s + bc;
    if (sum == 0) return 0;
    if (sum <= 64) return -2;
    if (sum <= 84) return -1;
    if (sum <= 124) return 0;
    if (sum <= 164) return 1;
    return 1 + ((sum - 125) ~/ 80);
  }

  bool statsComplete() => statPool.isEmpty;

  final List<int> skillPool = [70, 60, 60, 50, 50, 50, 40, 40, 40];
  final Map<String, Skill> skills = {
    "Antropologia": Skill(1),
    "Archeologia": Skill(1),
    "Broń palna (Broń Krótka)": Skill(20),
    "Broń palna (Karabin)": Skill(20),
    "Broń palna (Strzelba)": Skill(20),
    "Broń palna (Łuk)": Skill(20),
    "Charakteryzacja": Skill(5),
    "Elektryka": Skill(10),
    "Gadanina": Skill(5),
    "Historia": Skill(5),
    "Jeździectwo": Skill(5),
    "Język obcy": Skill(1),
    "Księgowość": Skill(5),
    "Mechanika": Skill(10),
    "Medycyna": Skill(1),
    "Nasłuchiwanie": Skill(20),
    "Nawigacja": Skill(10),
    "Okultyzm": Skill(5),
    "Perswazja": Skill(10),
    "Pierwsza pomoc": Skill(30),
    "Pilotowanie": Skill(1),
    "Pływanie": Skill(20),
    "Prawo": Skill(5),
    "Prowadzenie samochodu": Skill(20),
    "Psychologia": Skill(9),
    "Psychoanaliza": Skill(1),
    "Rzucanie": Skill(20),
    "Skakanie": Skill(20),
    "Spostrzegawczość": Skill(25),
    "Sztuka przetrwania": Skill(10),
    "Sztuka rzemiosło": Skill(5),
    "Ślusarstwo": Skill(1),
    "Tropienie": Skill(10),
    "Ukrywanie": Skill(20),
    "Unik": Skill(0), // Baza wyliczana z ZR (patrz assignStat)
    "Urok osobisty": Skill(15),
    "Walka wręcz": Skill(25),
    "Wiedza o naturze": Skill(10),
    "Wspinaczka": Skill(20),
    "Wycena": Skill(5),
    "Zastraszanie": Skill(15),
    "Zręczne palce": Skill(10),
  };

  void assignSkill(String name, int value) {
    setState(() {
      if (!skillPool.contains(value)) return;
      final skill = skills[name]!;
      if (skill.bonus != null) skillPool.add(skill.bonus!);
      skill.bonus = value;
      skillPool.remove(value);
    });
  }

  void resetSkill(String name) {
    setState(() {
      final skill = skills[name]!;
      if (skill.bonus != null) {
        skillPool.add(skill.bonus!);
        skill.bonus = null;
      }
    });
  }

  void next() {
    if (step == 1 && !statsComplete()) return;
    setState(() => step++);
  }

  void back() => setState(() => step--);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: Text("Kreator Postaci (Slot ${widget.slot})",
            style: const TextStyle(color: Colors.amber)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          Expanded(child: _step()), // Usunięto sztuczne ograniczenia z builda
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            if (step > 0)
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3E2723),
                      foregroundColor: Colors.amber),
                  onPressed: back,
                  child: const Text("Wstecz")),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3E2723),
                    foregroundColor: Colors.amber),
                onPressed: next,
                child: const Text("Dalej"))
          ])
        ]),
      ),
    );
  }

  Widget _step() {
    switch (step) {
      case 0:
        return _step1();
      case 1:
        return _step2();
      case 2:
        return _step3();
      case 3:
        return _step4();
      default:
        return _step5();
    }
  }

  // Dodano SingleChildScrollView bezpośrednio do kroków 1, 2, 3 i 5
  Widget _step1() => SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Imię", style: TextStyle(color: Colors.white)),
          TextField(
              controller: nameCtrl,
              style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          const Text("Wiek", style: TextStyle(color: Colors.white)),
          TextField(
              controller: ageCtrl, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          const Text("Płeć", style: TextStyle(color: Colors.white)),
          DropdownButtonFormField<String>(
              dropdownColor: const Color(0xFF2C2621),
              initialValue: gender,
              style: const TextStyle(color: Colors.white),
              items: const [
                DropdownMenuItem(
                    value: "M",
                    child: Text("Mężczyzna",
                        style: TextStyle(color: Colors.white))),
                DropdownMenuItem(
                    value: "K",
                    child:
                        Text("Kobieta", style: TextStyle(color: Colors.white)))
              ],
              onChanged: (v) => setState(() => gender = v!)),
          const SizedBox(height: 10),
          const Text("Miejsce urodzenia",
              style: TextStyle(color: Colors.white)),
          TextField(
              controller: birthCtrl,
              style: const TextStyle(color: Colors.white))
        ]),
      );

  Widget _step2() => SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Pula statystyk: ${statPool.join(", ")}",
              style: const TextStyle(color: Colors.amber, fontSize: 16)),
          const SizedBox(height: 10),
          _stat("Siła (S)", "S", s),
          _stat("Kondycja (KON)", "KON", kon),
          _stat("Budowa ciała (BC)", "BC", bc),
          _stat("Zręczność (ZR)", "ZR", zr),
          _stat("Inteligencja (INT)", "INT", inte),
          _stat("Moc (MOC)", "MOC", moc),
          _stat("Wygląd (WYG)", "WYG", wyg),
          _stat("Wykształcenie (WYK)", "WYK", wyk)
        ]),
      );

  Widget _stat(String label, String key, int value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: Text("$label: $value",
                  style: const TextStyle(color: Colors.white))),
          Wrap(
              spacing: 4,
              children: statPool
                  .map((v) => ChoiceChip(
                      label: Text("$v"),
                      selected: false,
                      onSelected: (_) => assignStat(key, v)))
                  .toList()),
          TextButton(
              onPressed: () => resetStat(key),
              child: const Text("RESET", style: TextStyle(color: Colors.red)))
        ]),
      );

  Widget _step3() => SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("STATYSTYKI POCHODNE",
              style: TextStyle(
                  color: Colors.amber,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Text(
              "Punkty Wytrzymałości (HP): ${((s + kon) / 10).floor()} / ${((s + kon) / 10).floor()}",
              style: const TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 10),
          Text("Poczytalność (SAN): $moc / $moc",
              style: const TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 10),
          Text("Modyfikator Obrażeń (MO): ${getModyfikatorObrazen()}",
              style: const TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text("Krzepa: ${getKrzepa()}",
              style: const TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text("Ruch: 8",
              style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 10),
          Text("Szczęście: $szczescie",
              style: const TextStyle(color: Colors.white, fontSize: 16))
        ]),
      );

  // Nowy wiersz skilli - kompaktowy układ podobny do cech
  Widget _skillRow(String name, Skill skill) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(children: [
          SizedBox(
              width: 140,
              child: Text("$name (${skill.base}%)",
                  style: const TextStyle(color: Colors.white, fontSize: 13))),
          Expanded(
            child: Wrap(
                spacing: 4,
                runSpacing: -10, // Zagęszcza rzędy pionowo
                children: skillPool
                    .map((v) => ChoiceChip(
                        label: Text("$v", style: const TextStyle(fontSize: 11)),
                        selected: skill.bonus == v,
                        onSelected: (_) => assignSkill(name, v)))
                    .toList()),
          ),
          TextButton(
              onPressed: () => resetSkill(name),
              child: const Text("RESET",
                  style: TextStyle(color: Colors.red, fontSize: 12)))
        ]));
  }

  // Usunięto SizedBox(height: 400), teraz Expanded z ListView sam zajmie całe dostępne miejsce w pionie
  Widget _step4() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("PULA SKILLI: ${List<int>.from(skillPool)..sort()}",
            style: const TextStyle(color: Colors.amber, fontSize: 16)),
        const SizedBox(height: 10),
        Expanded(
          child: ListView(
              children: skills.entries
                  .map((e) => _skillRow(e.key, e.value))
                  .toList()),
        )
      ]);

  Widget _step5() {
    final hpMax = ((s + kon) / 10).floor();
    final sanMax = moc;
    return SingleChildScrollView(
      child: Column(children: [
        const Text("KARTA POSTACI GOTOWA",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.amber)),
        const SizedBox(height: 20),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3E2723),
                foregroundColor: Colors.amber),
            onPressed: () async {
              final character = Character(
                  name: nameCtrl.text,
                  age: int.tryParse(ageCtrl.text) ?? 0,
                  gender: gender,
                  birthPlace: birthCtrl.text,
                  s: s,
                  kon: kon,
                  bc: bc,
                  zr: zr,
                  inte: inte,
                  moc: moc,
                  wyk: wyk,
                  wyg: wyg,
                  hpMax: hpMax,
                  hpCurrent: hpMax,
                  sanMax: sanMax,
                  sanCurrent: sanMax,
                  ruch: 8,
                  krzepa: getKrzepa(), // Przypisana wyliczona Krzepa
                  szczescie: szczescie,
                  umiejetnosci: {
                    for (final e in skills.entries) e.key: e.value.finalValue
                  });
              GameState.character.value = character;

              await SaveSystem.save(
                  SavedCharacter.fromCharacter(character), widget.slot);

              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Postać zapisana w slocie ${widget.slot}")));
            },
            child: const Text("ZAPISZ POSTAĆ")),
        const SizedBox(height: 10),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade900,
                foregroundColor: Colors.white),
            onPressed: () {
              if (GameState.character.value == null) return;
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          AdventureScreen(adventureData: adventureData)));
            },
            child: const Text("GRAJ")),
      ]),
    );
  }
}
