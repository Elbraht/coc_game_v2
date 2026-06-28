import 'package:flutter/material.dart';

class TestHud extends StatelessWidget {
  final String skill;
  final int skillValue;
  final int roll;
  final int target;
  final String result;

  const TestHud({
    super.key,
    required this.skill,
    required this.skillValue,
    required this.roll,
    required this.target,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final success = roll <= target;

    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.black87,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "TEST UMIEJĘTNOŚCI",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          Text("Skill: $skill", style: const TextStyle(color: Colors.white)),
          Text("Poziom: $skillValue%", style: const TextStyle(color: Colors.white)),
          Text("Rzut: $roll", style: const TextStyle(color: Colors.white)),
          Text("Próg: $target", style: const TextStyle(color: Colors.white)),

          const SizedBox(height: 6),

          Text(
            success ? "SUKCES" : "PORAZKA",
            style: TextStyle(
              color: success ? Colors.green : Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            result,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}