class Quest {
  final String questId;
  final String name;
  final String description;
  final String image;
  final List<String> condition;
  final String conditionDescription;
  final String rewardId;
  final String rewardType;
  final int point;
  final String id;
  final String state;
  final dynamic options;
  final String frequency;

  Quest({
    required this.questId,
    required this.name,
    required this.description,
    required this.image,
    required this.condition,
    required this.conditionDescription,
    required this.rewardId,
    required this.rewardType,
    required this.point,
    required this.id,
    required this.state,
    required this.options,
    required this.frequency,
  });

  static fromMap(Map<String, dynamic> e) {
    return Quest(
      questId: e["questId"],
      name: e["name"],
      description: e["description"],
      image: e["image"],
      condition: e["condition"].cast<String>(),
      conditionDescription: e["conditionDetail"] ?? "",
      rewardId: e["rewardId"],
      rewardType: e["rewardType"],
      point: e["point"] ?? 0,
      id: e["questId"],
      state: e["state"] ?? "",
      options: e["options"],
      frequency: e["frequency"],
    );
  }
}
