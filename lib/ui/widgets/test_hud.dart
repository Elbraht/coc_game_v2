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
    final isSuccess = result == "SUCCESS";

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "TEST UMIEJĘTNOŚCI",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text("Cecha/Skill: $skill",
              style: const TextStyle(color: Colors.white)),
          Text("Baza postaci: $skillValue%",
              style: const TextStyle(color: Colors.white)),
          Text("Rzut kością: $roll",
              style: const TextStyle(color: Colors.white)),
          Text("Wymagany próg (z modyf.): $target",
              style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 6),
          Text(
            isSuccess ? "SUKCES" : "PORAŻKA",
            style: TextStyle(
              color: isSuccess ? Colors.green : Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
