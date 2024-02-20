class Quest {
  final String questId;
  final String name;
  final String description;
  final String image;
  final List<String> condition;
  final String conditionDescription;
  final String rewardId;
  final String rewardType;

  Quest({
    required this.questId,
    required this.name,
    required this.description,
    required this.image,
    required this.condition,
    required this.conditionDescription,
    required this.rewardId,
    required this.rewardType,
  });
}
