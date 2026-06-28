enum EffectType {
  hp,
  san,
  skill,
}

class AdventureEffect {
  final EffectType type;
  final String? skillName;
  final int value;

  const AdventureEffect.hp(this.value)
      : type = EffectType.hp,
        skillName = null;

  const AdventureEffect.san(this.value)
      : type = EffectType.san,
        skillName = null;

  const AdventureEffect.skill(this.skillName, this.value)
      : type = EffectType.skill;
}