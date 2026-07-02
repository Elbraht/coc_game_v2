import 'package:flutter/material.dart';
import 'dart:math'; // Wymagane dla funkcji max() przy wyświetlaniu HP

import 'package:coc_game_v2/models/inventory_models.dart';
import 'package:coc_game_v2/models/npc_model.dart';
import 'package:coc_game_v2/core/roll_system.dart';
import 'package:coc_game_v2/character.dart';
import 'package:coc_game_v2/adventure/adventure_node.dart';
import 'package:coc_game_v2/game_state.dart';

enum CombatPhase { introduction, playerAction, npcAction, roundEnd, matchOver }

class LogEntry {
  final String text;
  final Color color;
  final bool isBold;
  LogEntry(this.text, {this.color = Colors.white54, this.isBold = false});
}

class CombatScreen extends StatefulWidget {
  final Character player;
  final NPC enemy;
  const CombatScreen({super.key, required this.player, required this.enemy});

  @override
  State<CombatScreen> createState() => _CombatScreenState();
}

class _CombatScreenState extends State<CombatScreen> {
  final List<LogEntry> _combatLog = [];

  late NPC _currentEnemy;
  int _roundNumber = 1;
  final int _distanceMeters = 15;
  CombatPhase _currentPhase = CombatPhase.introduction;

  Weapon? _selectedWeapon;

  bool _playerTookActionThisRound = false;
  bool _npcTookActionThisRound = false;
  bool _isPlayerFirstInInitiative = true;

  @override
  void initState() {
    super.initState();
    _currentEnemy = widget.enemy;
    _initializeCombat();
  }

  void _addToLog(String text,
      {Color color = Colors.white54, bool isBold = false}) {
    if (mounted) {
      setState(() =>
          _combatLog.insert(0, LogEntry(text, color: color, isBold: isBold)));
    }
  }

  // ====================================================================
  // POPRAWKA Z KROKU 2: Czyste i bezpośrednie pobieranie statystyk
  // ====================================================================
  int _getPlayerSkill(Character player, String skillName) {
    return player.getStatOrSkill(skillName);
  }

  void _showCombatReportDialog(String title, String details, String damageInfo,
      {bool isPlayerSuccess = true}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2621),
        title: Text(title,
            style: TextStyle(
                color: isPlayerSuccess ? Colors.greenAccent : Colors.redAccent,
                fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(details,
                style: const TextStyle(
                    color: Colors.white, fontSize: 15, height: 1.4)),
            const Divider(color: Colors.white24, height: 20),
            Text(damageInfo,
                style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _checkPostActionVitality();
            },
            child: const Text("DALEJ",
                style: TextStyle(
                    color: Colors.amber, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  void _checkPostActionVitality() {
    final player = GameState.character.value ?? widget.player;
    if (player.hpCurrent <= 0 ||
        player.sanCurrent <= 0 ||
        _currentEnemy.hpCurrent <= 0) {
      setState(() => _currentPhase = CombatPhase.matchOver);
    } else {
      _cycleCombatFlow();
    }
  }

  void _initializeCombat() {
    _addToLog("⚔️ INICJACJA STARCIA: ${_currentEnemy.name} atakuje!",
        color: Colors.amber, isBold: true);
    _startNewRound();
  }

  void _startNewRound() {
    if (_currentPhase == CombatPhase.matchOver) return;
    _playerTookActionThisRound = false;
    _npcTookActionThisRound = false;
    _addToLog("--- ⏳ RUNDA $_roundNumber ---",
        color: Colors.amber, isBold: true);

    final player = GameState.character.value ?? widget.player;
    _isPlayerFirstInInitiative = player.zr >= _currentEnemy.zr;

    if (_isPlayerFirstInInitiative) {
      _addToLog("⏱️ Twój ruch (wyższa inicjatywa)!", color: Colors.greenAccent);
      setState(() => _currentPhase = CombatPhase.playerAction);
    } else {
      _addToLog("⏱️ Wróg jest szybszy! Przygotuj się na obronę.",
          color: Colors.orangeAccent);
      setState(() => _currentPhase = CombatPhase.npcAction);
      _executeNpcTurn();
    }
  }

  void _cycleCombatFlow() {
    if (_currentPhase == CombatPhase.matchOver) return;

    if (_isPlayerFirstInInitiative) {
      if (_playerTookActionThisRound && !_npcTookActionThisRound) {
        setState(() => _currentPhase = CombatPhase.npcAction);
        _executeNpcTurn();
      } else if (_playerTookActionThisRound && _npcTookActionThisRound) {
        _advanceRoundNumber();
      }
    } else {
      if (_npcTookActionThisRound && !_playerTookActionThisRound) {
        setState(() => _currentPhase = CombatPhase.playerAction);
      } else if (_npcTookActionThisRound && _playerTookActionThisRound) {
        _advanceRoundNumber();
      }
    }
  }

  void _advanceRoundNumber() {
    setState(() {
      _roundNumber++;
      _startNewRound();
    });
  }

  void _executePlayerFirearmAttack() {
    if (_selectedWeapon == null) return;
    final player = GameState.character.value ?? widget.player;
    _selectedWeapon!.magazineCurrent--;

    int skillValue = _getPlayerSkill(player, _selectedWeapon!.skillName);
    RollOutcome pRoll = RollSystem.test(skillValue, Difficulty.normal, 0);
    bool hit = pRoll.result != RollResult.failure &&
        pRoll.result != RollResult.criticalFailure;

    String details = "Twój test: ${_selectedWeapon!.skillName} ($skillValue%)\n"
        "Rzut kością: ${pRoll.rollValue} -> ${RollSystem.resultToText(pRoll.result)}";

    if (hit) {
      _currentEnemy.hpCurrent -= 4;
      _addToLog("🎯 Trafienie ze strzału z ${_selectedWeapon!.name}!",
          color: Colors.greenAccent);
      _showCombatReportDialog("Strzał", details, "Zadano obrażenia wrogowi.");
    } else {
      _addToLog("💨 Pudło!", color: Colors.redAccent);
      _showCombatReportDialog("Strzał", details, "Kula minęła cel.",
          isPlayerSuccess: false);
    }

    _playerTookActionThisRound = true;
  }

  void _executePlayerMeleeAction() {
    final player = GameState.character.value ?? widget.player;
    Weapon meleeWeapon = _selectedWeapon ?? _getFists();

    int pSkill = _getPlayerSkill(player, meleeWeapon.skillName);
    RollOutcome pRoll = RollSystem.test(pSkill, Difficulty.normal, 0);

    int npcSkillValue = _currentEnemy.attacks.isNotEmpty
        ? _currentEnemy.attacks.first.skillValue
        : 30;
    bool playerWins = pRoll.rollValue < npcSkillValue;

    String details = "Twój cios wręcz: ${meleeWeapon.name} ($pSkill%)\n"
        "Twój rzut: ${pRoll.rollValue}";

    if (playerWins) {
      _currentEnemy.hpCurrent -= 3;
      _addToLog("👊 Trafienie wręcz!", color: Colors.greenAccent);
      _showCombatReportDialog(
          "Walka wręcz", details, "Przeciwnik otrzymuje rany.");
    } else {
      player.hpCurrent -= 2;
      _addToLog("💥 Oberwałeś w zwarciu!", color: Colors.redAccent);
      _showCombatReportDialog(
          "Walka wręcz", details, "Wróg skontrował Twój atak!",
          isPlayerSuccess: false);
    }

    _playerTookActionThisRound = true;
  }

  void _executePlayerDefenseReaction(bool isDodge, NpcAttack npcAtk) {
    final player = GameState.character.value ?? widget.player;
    if (isDodge) {
      _addToLog("✨ Wykonujesz udany Unik!", color: Colors.cyanAccent);
      _showCombatReportDialog(
          "Obrona", "Unik pomyślny!", "Chronisz się przed ranami.");
    } else {
      player.hpCurrent -= 3;
      _addToLog("💥 Nieudany kontratak!", color: Colors.redAccent);
      _showCombatReportDialog(
          "Obrona", "Wróg przełamał Twoją gardę!", "Otrzymujesz obrażenia.",
          isPlayerSuccess: false);
    }
    _npcTookActionThisRound = true;
  }

  void _executeNpcTurn() {
    if (_currentEnemy.hpCurrent <= 0) return;
    NpcAttack currentAttack = _currentEnemy.attacks.isNotEmpty
        ? _currentEnemy.attacks.first
        : NpcAttack(
            name: "Brutalne uderzenie",
            damageExpression: "1k6",
            skillValue: 30);

    _addToLog(
        "👹 ${_currentEnemy.name} wyprowadza cios: ${currentAttack.name}!",
        color: Colors.redAccent);
  }

  Weapon _getFists() => Weapon(
      name: "Pięści (Bijatyka)",
      description: "",
      weight: 0,
      value: 0,
      type: WeaponType.meele,
      damageExpression: "1k3",
      skillName: "Walka wręcz",
      hasDamageBonus: true,
      baseRange: 0,
      shotsPerRound: 1,
      magazineMax: 0,
      caliber: "Brak");

  List<Weapon> _buildAvailableWeaponsPool(Character player) {
    List<Weapon> pool = [_getFists()];
    // Brak ostrzeżeń (usunięto zbędny null check, dodajemy wszystko z listy weapons)
    pool.addAll(player.weapons);
    return pool;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Character?>(
        valueListenable: GameState.character,
        builder: (context, activePlayer, _) {
          final player = activePlayer ?? widget.player;
          List<Weapon> availableWeapons = _buildAvailableWeaponsPool(player);

          if (_selectedWeapon == null && availableWeapons.length > 1) {
            _selectedWeapon = availableWeapons
                .firstWhere((w) => w.name != "Pięści (Bijatyka)");
          }

          return Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 50, left: 16, right: 16, bottom: 12),
                  color: Colors.grey[950],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("HP: ${player.hpCurrent}/${player.hpMax}",
                          style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold)),
                      Text("DYSTANS: $_distanceMeters m",
                          style: const TextStyle(color: Colors.yellow)),
                      Text(
                          "${_currentEnemy.name}: ${max(0, _currentEnemy.hpCurrent)} HP",
                          style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: _combatLog.length,
                    itemBuilder: (c, i) => Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(_combatLog[i].text,
                          style: TextStyle(
                              color: _combatLog[i].color,
                              fontWeight: _combatLog[i].isBold
                                  ? FontWeight.bold
                                  : FontWeight.normal)),
                    ),
                  ),
                ),
                _buildControlPanel(player, availableWeapons),
              ],
            ),
          );
        });
  }

  Widget _buildControlPanel(Character player, List<Weapon> availableWeapons) {
    if (_currentPhase == CombatPhase.matchOver) {
      bool win = _currentEnemy.hpCurrent <= 0;
      return Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: win ? Colors.green : Colors.red,
              minimumSize: const Size.fromHeight(50)),
          onPressed: () => Navigator.pop(context, win),
          child: Text(win ? "ZWYCIĘSTWO" : "ZGINĄŁEŚ",
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      );
    }

    if (_currentPhase == CombatPhase.playerAction) {
      return Container(
        color: Colors.grey[900],
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            DropdownButton<Weapon>(
              dropdownColor: Colors.grey[900],
              value: _selectedWeapon ?? availableWeapons.first,
              items: availableWeapons
                  .map((w) => DropdownMenuItem(
                      value: w,
                      child: Text(w.name,
                          style: const TextStyle(color: Colors.white))))
                  .toList(),
              onChanged: (val) => setState(() => _selectedWeapon = val),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3E2723),
                  foregroundColor: Colors.amber,
                  minimumSize: const Size.fromHeight(45)),
              onPressed: () {
                if (_selectedWeapon != null && _selectedWeapon!.isFirearm) {
                  _executePlayerFirearmAttack();
                } else {
                  _executePlayerMeleeAction();
                }
              },
              child: Text(
                  (_selectedWeapon != null && _selectedWeapon!.isFirearm)
                      ? "ODDAJ STRZAŁ"
                      : "ZADAJ CIOS WRĘCZ"),
            ),
          ],
        ),
      );
    }

    if (_currentPhase == CombatPhase.npcAction) {
      NpcAttack currentAttack = _currentEnemy.attacks.isNotEmpty
          ? _currentEnemy.attacks.first
          : NpcAttack(
              name: "Brutalne uderzenie",
              damageExpression: "1k6",
              skillValue: 30);

      return Container(
        color: Colors.grey[950],
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () =>
                        _executePlayerDefenseReaction(true, currentAttack),
                    child: const Text("UNIKAJ CIOSU",
                        style: TextStyle(color: Colors.white)))),
            const SizedBox(width: 12),
            Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade800),
                    onPressed: () =>
                        _executePlayerDefenseReaction(false, currentAttack),
                    child: const Text("KONTRATAKUJ",
                        style: TextStyle(color: Colors.white)))),
          ],
        ),
      );
    }

    return const SizedBox();
  }
}
