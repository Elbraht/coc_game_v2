enum WeaponType { meele, handgun, rifle, shotgun, submachine, heavy, thrown }

abstract class GameItem {
  final String name;
  final String description;
  final double weight;
  final int value;

  GameItem({
    required this.name,
    required this.description,
    required this.weight,
    required this.value,
  });
}

class GeneralItem extends GameItem {
  GeneralItem({
    required super.name,
    required super.description,
    required super.weight,
    required super.value,
  });
}

class Ammunition extends GameItem {
  final String caliber;
  int count;

  Ammunition({
    required super.name,
    required super.description,
    required super.weight,
    required super.value,
    required this.caliber,
    required this.count,
  });
}

class Weapon extends GameItem {
  final WeaponType type;
  final String damageExpression;
  final String skillName;
  final bool hasDamageBonus;
  final bool hasHalfDamageBonus;
  final int baseRange;
  final int shotsPerRound;
  final int magazineMax;
  int magazineCurrent;
  final String caliber;

  Weapon({
    required super.name,
    required super.description,
    required super.weight,
    required super.value,
    required this.type,
    required this.damageExpression,
    required this.skillName,
    this.hasDamageBonus = false,
    this.hasHalfDamageBonus = false,
    required this.baseRange,
    required this.shotsPerRound,
    required this.magazineMax,
    required this.caliber,
  }) : magazineCurrent = magazineMax;

  bool get isFirearm =>
      type == WeaponType.handgun ||
      type == WeaponType.rifle ||
      type == WeaponType.shotgun ||
      type == WeaponType.submachine ||
      type == WeaponType.heavy;
}

class Spell {
  final String name;
  final String description;
  final int mpCost;
  final int sanCost;

  Spell(this.name, this.description, this.mpCost, this.sanCost);
}

class Clue {
  final String name;
  final String description;
  Clue(this.name, this.description);
}
