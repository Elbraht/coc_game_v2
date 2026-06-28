import 'adventure_effect.dart';

class AdventureNode {
  final String text;
  final String? skill;
  final int modifier;

  final int? successNext;
  final int? failNext;

  final List<AdventureEffect> onSuccess;
  final List<AdventureEffect> onFail;

  final bool isEnd;

  AdventureNode({
    required this.text,
    this.skill,
    this.modifier = 0,
    this.successNext,
    this.failNext,
    this.onSuccess = const [],
    this.onFail = const [],
    this.isEnd = false,
  });
}
