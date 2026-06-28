import 'package:flutter/material.dart';
import 'package:coc_game_v2/game_state.dart';
import 'package:coc_game_v2/character.dart';
import 'dart:math';
import 'package:coc_game_v2/ui/adventure_screen.dart';
import '../save/save_system.dart';
import '../save/saved_character.dart';

class Skill {
  final int base;
  int? bonus;

  Skill(this.base, {this.bonus});

  int get finalValue => bonus ?? base;
}

class CharacterCreationFlow extends StatefulWidget {
  final int slot;

  const CharacterCreationFlow({
    super.key,
    required this.slot,
  });

  @override
  State<CharacterCreationFlow> createState() => _CharacterCreationFlowState();
}

class _CharacterCreationFlowState extends State<CharacterCreationFlow> {
  int step = 0;
  final Random _rng = Random();

  int d6() => _rng.nextInt(6) + 1;

  late final int SZCZESCIE;

  @override
  void initState() {
    super.initState();
    SZCZESCIE = (d6() + d6() + d6()) * 5;
  }

  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final birthCtrl = TextEditingController();
  String gender = "M";

  int S = 0, KON = 0, BC = 0, ZR = 0, WYG = 0, INT = 0, MOC = 0, WYK = 0;

  List<int> statPool = [80, 70, 60, 60, 50, 50, 50, 40];
  final Map<String, int> selectedStats = {};

  void assignStat(String key, int value) {
    setState(() {
      if (!statPool.contains(value)) return;

      if (selectedStats.containsKey(key)) {
        statPool.add(selectedStats[key]!);
      }

      selectedStats[key] = value;
      statPool.remove(value);

      switch (key) {
        case "S":
          S = value;
          break;
        case "KON":
          KON = value;
          break;
        case "BC":
          BC = value;
          break;
        case "ZR":
          ZR = value;
          break;
        case "WYG":
          WYG = value;
          break;
        case "INT":
          INT = value;
          break;
        case "MOC":
          MOC = value;
          break;
        case "WYK":
          WYK = value;
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
          S = 0;
          break;
        case "KON":
          KON = 0;
          break;
        case "BC":
          BC = 0;
          break;
        case "ZR":
          ZR = 0;
          break;
        case "WYG":
          WYG = 0;
          break;
        case "INT":
          INT = 0;
          break;
        case "MOC":
          MOC = 0;
          break;
        case "WYK":
          WYK = 0;
          break;
      }
    });
  }

  bool statsComplete() => statPool.isEmpty;

  int get HP => ((S + KON) / 10).floor();
  int get SAN => MOC;
  int get RUCH => 8;

  int get KRZEPA {
    final suma = S + KON;
    if (suma <= 64) return 1;
    if (suma <= 84) return 2;
    if (suma <= 124) return 3;
    if (suma <= 164) return 4;
    return 5;
  }

  final List<int> skillPool = [70, 60, 60, 50, 50, 50, 40, 40, 40];

  final Map<String, Skill> skills = {
    "Antropologia": Skill(1),
    "Archeologia": Skill(1),
    "Broń palna krótka": Skill(20),
    "Broń palna długa": Skill(25),
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
    "Unik": Skill(0),
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

      if (skill.bonus != null) {
        skillPool.add(skill.bonus!);
      }

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
      appBar: AppBar(title: const Text("Character Creator")),
      body: Column(
        children: [
          Expanded(child: _step()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (step > 0)
                ElevatedButton(onPressed: back, child: const Text("Wstecz")),
              ElevatedButton(onPressed: next, child: const Text("Dalej")),
            ],
          )
        ],
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

  // STEP 1
  Widget _step1() {
    return Column(
      children: [
        const Text("Imię"),
        TextField(controller: nameCtrl),
        const Text("Wiek"),
        TextField(controller: ageCtrl),
        const Text("Płeć"),
        DropdownButton(
          value: gender,
          items: const [
            DropdownMenuItem(value: "M", child: Text("Mężczyzna")),
            DropdownMenuItem(value: "K", child: Text("Kobieta")),
          ],
          onChanged: (v) => setState(() => gender = v!),
        ),
        const Text("Miejsce urodzenia"),
        TextField(controller: birthCtrl),
      ],
    );
  }

  // STEP 2 (ORYGINAŁ + WYG PRZYWRÓCONY)
  Widget _step2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Pula: ${statPool.join(", ")}"),
        const SizedBox(height: 10),
        _stat("Siła", "S", S),
        _stat("Kondycja", "KON", KON),
        _stat("Budowa ciała", "BC", BC),
        _stat("Zręczność", "ZR", ZR),
        _stat("Inteligencja", "INT", INT),
        _stat("Moc", "MOC", MOC),
        _stat("Wygląd", "WYG", WYG),
        _stat("Wykształcenie", "WYK", WYK),
      ],
    );
  }

  Widget _stat(String label, String key, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("$label: $value"),
        Wrap(
          children: statPool.map((v) {
            return ChoiceChip(
              label: Text("$v"),
              selected: false,
              onSelected: (_) => assignStat(key, v),
            );
          }).toList(),
        ),
        TextButton(
          onPressed: () => resetStat(key),
          child: const Text("RESET"),
        ),
      ],
    );
  }

  // STEP 3
  Widget _step3() {
    final hpMax = ((S + KON) / 10).floor();
    final sanMax = MOC;

    return Column(
      children: [
        Text("HP: $hpMax / $hpMax"),
        Text("SAN: $sanMax / $sanMax"),
        Text("Ruch: $RUCH"),
        Text("Krzepa: $KRZEPA"),
        Text("Szczęście: $SZCZESCIE"),
      ],
    );
  }

  // STEP 4
  Widget _step4() {
    final pool = List<int>.from(skillPool)..sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("PULA SKILLI: ${pool.join(", ")}"),
        const SizedBox(height: 10),
        Expanded(
          child: ListView(
            children: skills.entries.map((e) {
              final s = e.value;

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.key,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text("Baza: ${s.base}%"),
                      Text("Wybrana: ${s.finalValue}%"),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        children: pool.map((v) {
                          return ChoiceChip(
                            label: Text("$v"),
                            selected: s.bonus == v,
                            onSelected: (_) => assignSkill(e.key, v),
                          );
                        }).toList(),
                      ),
                      TextButton(
                        onPressed: () => resetSkill(e.key),
                        child: const Text("RESET"),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

// STEP 5
  Widget _step5() {
    final entries = skills.entries.toList();

    final hpMax = ((S + KON) / 10).floor();
    final sanMax = MOC;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "KARTA POSTACI",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text("DANE"),
          Text("Imię: ${nameCtrl.text}"),
          Text("Wiek: ${ageCtrl.text}"),
          Text("Płeć: $gender"),
          Text("Miejsce urodzenia: ${birthCtrl.text}"),
          const Divider(),
          const Text("CECHY"),
          Text("S: $S"),
          Text("KON: $KON"),
          Text("BC: $BC"),
          Text("ZR: $ZR"),
          Text("INT: $INT"),
          Text("MOC: $MOC"),
          Text("WYG: $WYG"),
          Text("WYK: $WYK"),
          const Divider(),
          const Text("POCHODNE"),
          Text("HP: $hpMax / $hpMax"),
          Text("SAN: $sanMax / $sanMax"),
          Text("RUCH: $RUCH"),
          Text("KRZEPA: $KRZEPA"),
          Text("SZCZĘŚCIE: $SZCZESCIE"),
          const Divider(),
          const Text("UMIEJĘTNOŚCI"),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: entries
                      .sublist(0, (entries.length / 2).ceil())
                      .map((e) => Text("${e.key}: ${e.value.finalValue}%"))
                      .toList(),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: entries
                      .sublist((entries.length / 2).ceil())
                      .map((e) => Text("${e.key}: ${e.value.finalValue}%"))
                      .toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final character = Character(
                name: nameCtrl.text,
                age: int.tryParse(ageCtrl.text) ?? 0,
                gender: gender,
                birthPlace: birthCtrl.text,
                S: S,
                KON: KON,
                BC: BC,
                ZR: ZR,
                INT: INT,
                MOC: MOC,
                WYK: WYK,
                WYG: WYG,
                HP_MAX: hpMax,
                HP_CURRENT: hpMax,
                SAN_MAX: sanMax,
                SAN_CURRENT: sanMax,
                RUCH: RUCH,
                KRZEPA: KRZEPA,
                SZCZESCIE: SZCZESCIE,
                skills: {
                  for (final e in skills.entries) e.key: e.value.finalValue
                },
              );

              // 🔥 FIX: ustawiamy character bezpośrednio (pewność natychmiastowa)
              GameState.character.value = character;
              GameState.refreshHUD();

              await SaveSystem.save(
                SavedCharacter.fromCharacter(character),
                0,
              );

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Postać zapisana")),
              );
            },
            child: const Text("ZAPISZ POSTAĆ"),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              final c = GameState.character.value;

              // 🔥 FIX: poprawny check (ValueNotifier!)
              if (c == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Najpierw zapisz postać")),
                );
                return;
              }

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const AdventureScreen(),
                ),
              );
            },
            child: const Text("GRAJ"),
          ),
        ],
      ),
    );
  }
}
