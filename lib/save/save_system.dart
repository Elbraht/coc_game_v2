import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'saved_character.dart';

class SaveSystem {
  static const String keyPrefix = "character_slot_";

  // =========================
  // 💾 SAVE SLOT
  // =========================
  static Future<void> save(SavedCharacter c, int slot) async {
    final jsonString = jsonEncode(c.toJson());
    final key = "$keyPrefix$slot";

    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, jsonString);
      return;
    }

    final file = await _getFile(slot);
    await file.writeAsString(jsonString);
  }

  // =========================
  // 📥 LOAD SLOT
  // =========================
  static Future<SavedCharacter?> load(int slot) async {
    try {
      final key = "$keyPrefix$slot";

      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        final data = prefs.getString(key);
        if (data == null) return null;

        return SavedCharacter.fromJson(jsonDecode(data));
      }

      final file = await _getFile(slot);
      if (!await file.exists()) return null;

      final data = await file.readAsString();
      return SavedCharacter.fromJson(jsonDecode(data));
    } catch (e) {
      debugPrint("LOAD ERROR: $e");
      return null;
    }
  }

  // =========================
  // ❓ CHECK SLOT
  // =========================
  static Future<bool> hasSave(int slot) async {
    final key = "$keyPrefix$slot";

    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(key);
    }

    final file = await _getFile(slot);
    return file.exists();
  }

  // =========================
  // 🗑 DELETE SLOT
  // =========================
  static Future<void> delete(int slot) async {
    final key = "$keyPrefix$slot";

    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
      return;
    }

    final file = await _getFile(slot);
    if (await file.exists()) {
      await file.delete();
    }
  }

  // =========================
  // 📁 FILE PATH
  // =========================
  static Future<File> _getFile(int slot) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/character_slot_$slot.json');
  }

  // =========================
  // 📋 LOAD ALL SLOTS
  // =========================
  static Future<List<SavedCharacter?>> loadAll() async {
    return [
      await load(1),
      await load(2),
      await load(3),
    ];
  }
}