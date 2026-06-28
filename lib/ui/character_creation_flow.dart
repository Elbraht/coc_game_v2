import 'dart:math';
import 'package:flutter/material.dart';
import 'package:coc_game_v2/game_state.dart';
import 'package:coc_game_v2/character.dart';
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

  late final int _szczescie;

  @override
  void initState() {
    super.initState();
    _szczescie =
        (_rng.nextInt(6) + 1 + _rng.nextInt(6) + 1 + _rng.nextInt(6) + 1) * 5;
  }

  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final birthCtrl = TextEditingController();
  String selectedGender = "Mężczyzna";

  final Map<String, int> stats = {
    "S": 0,
    "KON": 0,
    "BC": 0,
    "ZR": 0,
    "INT": 0,
    "MOC": 0,
    "WYK": 0,
    "WYG": 0
  };

  final Map<String, Skill> skills = {
    "Brazylijskie jiu-jitsu": Skill(25),
    "Broń Krótka": Skill(20),
    "Unik": Skill(30),
    "Spostrzegawczość": Skill(25),
    "Ukrywanie": Skill(10),
    "Psychologia": Skill(10),
    "Medycyna": Skill(5),
    "Okultyzm": Skill(5),
    "Język Obcy": Skill(1),
  };

  void rollStats() {
    setState(() {
      stats["S"] =
          (_rng.nextInt(6) + 1 + _rng.nextInt(6) + 1 + _rng.nextInt(6) + 1) * 5;
      stats["KON"] =
          (_rng.nextInt(6) + 1 + _rng.nextInt(6) + 1 + _rng.nextInt(6) + 1) * 5;
      stats["BC"] =
          (_rng.nextInt(6) + 1 + _rng.nextInt(6) + 1 + _rng.nextInt(6) + 1) * 5;
      stats["ZR"] =
          (_rng.nextInt(6) + 1 + _rng.nextInt(6) + 1 + _rng.nextInt(6) + 1) * 5;
      stats["WYG"] =
          (_rng.nextInt(6) + 1 + _rng.nextInt(6) + 1 + _rng.nextInt(6) + 1) * 5;

      stats["INT"] = ((_rng.nextInt(6) + 1 + _rng.nextInt(6) + 1) + 6) * 5;
      stats["WYK"] = ((_rng.nextInt(6) + 1 + _rng.nextInt(6) + 1) + 6) * 5;
      stats["MOC"] = ((_rng.nextInt(6) + 1 + _rng.nextInt(6) + 1) + 6) * 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kreator Postaci - Slot ${widget.slot}")),
      body: IndexedStack(
        index: step,
        children: [
          _buildPersonalStep(),
          _buildStatsStep(),
          _buildSkillsStep(),
          _buildSummaryStep(),
        ],
      ),
    );
  }

  Widget _buildPersonalStep() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Imię i Nazwisko")),
          TextField(
              controller: ageCtrl,
              decoration: const InputDecoration(labelText: "Wiek"),
              keyboardType: TextInputType.number),
          TextField(
              controller: birthCtrl,
              decoration:
                  const InputDecoration(labelText: "Miejsce Urodzenia")),
          DropdownButtonFormField<String>(
            initialValue: selectedGender,
            items: ["Mężczyzna", "Kobieta"]
                .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                .toList(),
            onChanged: (v) => setState(() => selectedGender = v ?? "Mężczyzna"),
            decoration: const InputDecoration(labelText: "Płeć"),
          ),
          const Spacer(),
          ElevatedButton(
              onPressed: () => setState(() => step = 1),
              child: const Text("DALEJ")),
        ],
      ),
    );
  }

  Widget _buildStatsStep() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton(
              onPressed: rollStats, child: const Text("LOSUJ STATYSTYKI")),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: stats.entries
                  .map((e) => ListTile(
                      title: Text(e.key), trailing: Text("${e.value}")))
                  .toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () => setState(() => step = 0),
                  child: const Text("WSTECZ")),
              ElevatedButton(
                  onPressed: () => setState(() => step = 2),
                  child: const Text("DALEJ")),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSkillsStep() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text("Rozdziel punkty (Uproszczone: wpisz bonus)",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView(
              children: skills.entries.map((e) {
                return ListTile(
                  title: Text(e.key),
                  subtitle: Text("Baza: ${e.value.base}%"),
                  trailing: SizedBox(
                    width: 60,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: "+0"),
                      onChanged: (v) {
                        final val = int.tryParse(v);
                        if (val != null) {
                          e.value.bonus = e.value.base + val;
                        }
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () => setState(() => step = 1),
                  child: const Text("WSTECZ")),
              ElevatedButton(
                  onPressed: () => setState(() => step = 3),
                  child: const Text("DALEJ")),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSummaryStep() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text("PODSUMOWANIE",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Divider(),
          Text("Imię: ${nameCtrl.text}"),
          Text("Wiek: ${ageCtrl.text}"),
          Text("Szczęście: $_szczescie"),
          const Spacer(),
          ElevatedButton(
            onPressed: () async {
              final hpMax = ((stats["S"] ?? 0) + (stats["KON"] ?? 0)) ~/ 10;
              final sanMax = stats["MOC"] ?? 0;

              final character = Character(
                name: nameCtrl.text,
                age: int.tryParse(ageCtrl.text) ?? 30,
                gender: selectedGender,
                birthPlace: birthCtrl.text,
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
                SZCZESCIE: _szczescie,
                skills: {
                  for (final e in skills.entries) e.key: e.value.finalValue
                },
              );

              GameState.character.value = character;
              GameState.refreshHUD();

              // Przechwytujemy messenger zanim użyjemy await
              final messenger = ScaffoldMessenger.of(context);

              await SaveSystem.save(
                SavedCharacter.fromCharacter(character),
                widget.slot,
              );

              // Bezpieczne użycie przechwyconego messengera bez odwoływania się do context
              messenger.showSnackBar(
                const SnackBar(content: Text("Postać zapisana")),
              );
            },
            child: const Text("ZAPISZ POSTAĆ"),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              final c = GameState.character.value;

              if (c == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Najpierw zapisz postać")),
                );
                return;
              }

              Navigator.pop(context);
            },
            child: const Text("POWRÓT"),
          ),
        ],
      ),
    );
  }
}
