import 'package:flutter/material.dart';
import 'package:coc_game_v2/game_state.dart';

class InventorySidePanel extends StatelessWidget {
  const InventorySidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1E1A17), // Ciemny, klimatyczny brąz
      child: ValueListenableBuilder(
        valueListenable: GameState.character,
        builder: (context, character, _) {
          if (character == null) {
            return const Center(
              child: Text("Brak aktywnego badacza", style: TextStyle(color: Colors.white54))
            );
          }

          // Dynamiczne obliczanie wagi całkowitej (Przedmioty + Bronie)
          double currentWeight = 0.0;
          for (var item in character.items) {
            currentWeight += item.weight;
          }
          for (var weapon in character.weapons) {
            currentWeight += weapon.weight;
          }

          double maxWeight = character.s / 2.0;
          bool isOverburdened = currentWeight > maxWeight;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //================================================================
              // NAGŁÓWEK PANELU (STATUS UDŹWIGU)
              //================================================================
              Container(
                padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
                color: Colors.black45,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "EKWIPUNEK BADACZA",
                      style: TextStyle(color: Colors.amber, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          isOverburdened ? Icons.warning_amber_rounded : Icons.fitness_center,
                          color: isOverburdened ? Colors.redAccent : Colors.amber.withValues(alpha: 0.7),
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Obciążenie: ${currentWeight.toStringAsFixed(1)} / ${maxWeight.toStringAsFixed(1)} kg",
                          style: TextStyle(
                            color: isOverburdened ? Colors.redAccent : Colors.white70,
                            fontSize: 14,
                            fontWeight: isOverburdened ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              //================================================================
              // LISTA KATEGORII EKWIPUNKU
              //================================================================
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  children: [
                    // --- KATEGORIA 1: PRZEDMIOTY ---
                    const _CategoryHeader(title: "PRZEDMIOTY OSOBISTE", icon: Icons.backpack),
                    const SizedBox(height: 6),
                    if (character.items.isEmpty)
                      const _EmptyCategoryText(text: "Brak przedmiotów w kieszeniach")
                    else
                      ...character.items.map((item) => _InventoryTile(
                            name: item.name,
                            subtitle: "${item.weight} kg",
                            icon: Icons.inventory_2, // Adekwatna ikona przedmiotu/skrzynki
                            iconColor: Colors.amber.shade600,
                            onDelete: () {
                              character.items.remove(item);
                              GameState.refreshHUD();
                            },
                          )),

                    const SizedBox(height: 24),

                    // --- KATEGORIA 2: BRONIE (NOWA FIX SEKCJA) ---
                    const _CategoryHeader(title: "POSIADANA BROŃ", icon: Icons.colorize_outlined),
                    const SizedBox(height: 6),
                    if (character.weapons.isEmpty)
                      const _EmptyCategoryText(text: "Nie posiadasz żadnej broni palnej ani białej")
                    else
                      ...character.weapons.map((weapon) => _InventoryTile(
                            name: weapon.name,
                            subtitle: "${weapon.weight} kg | Amunicja: ${weapon.magazineCurrent}/${weapon.magazineMax}",
                            icon: Icons.track_changes, // Celownik rewolweru - adekwatna ikona oręża pistoletu
                            iconColor: Colors.red.shade400,
                            onDelete: () {
                              character.weapons.remove(weapon);
                              GameState.refreshHUD();
                            },
                          )),

                    const SizedBox(height: 24),

                    // --- KATEGORIA 3: CZARY ---
                    const _CategoryHeader(title: "KRAKOWSKIE OKULTYZM / CZARY", icon: Icons.auto_stories),
                    const SizedBox(height: 6),
                    if (character.spells.isEmpty)
                      const _EmptyCategoryText(text: "Nie znasz żadnych mrocznych inkantacji")
                    else
                      ...character.spells.map((spell) => ListTile(
                            title: Text(spell.name, style: const TextStyle(color: Colors.white70)),
                          )),

                    const SizedBox(height: 24),

                    // --- KATEGORIA 4: WSKAZÓWKI ---
                    const _CategoryHeader(title: "ŚLEDZTWO & WSKAZÓWKI", icon: Icons.search),
                    const SizedBox(height: 6),
                    if (character.clues.isEmpty)
                      const _EmptyCategoryText(text: "Brak zebranych dowodów w księdze")
                    else
                      ...character.clues.map((clue) => ListTile(
                            title: Text(clue.name, style: const TextStyle(color: Colors.white70)),
                          )),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// WIŻDET NAGŁÓWKA KATEGORII
class _CategoryHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _CategoryHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.amber, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(color: Colors.amber, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.1),
        ),
        const Expanded(child: Divider(color: Colors.white10, indent: 10)),
      ],
    );
  }
}

// WIDŻET DLA PUSTEJ KATEGORII
class _EmptyCategoryText extends StatelessWidget {
  final String text;
  const _EmptyCategoryText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 26, top: 4),
      child: Text(text, style: const TextStyle(color: Colors.white30, fontSize: 13, fontStyle: FontStyle.italic)),
    );
  }
}

// WIDŻET KAFFELKA PRZEDMIOTU / BRONI
class _InventoryTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onDelete;

  const _InventoryTile({
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        leading: Icon(icon, color: iconColor, size: 22),
        title: Text(name, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 15, fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
          onPressed: onDelete,
        ),
      ),
    );
  }
}