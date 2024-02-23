class Quest {
  final String id;
  final String name;
  final String description;
  final String image;
  final List<String> condition;
  final String? conditionDescription;
  final String rewardId;
  final String rewardType;
  final int point;
  final String state;
  final dynamic options;
  final String frequency;

  Quest({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.condition,
    this.conditionDescription,
    required this.rewardId,
    required this.rewardType,
    required this.point,
    required this.state,
    required this.options,
    required this.frequency,
  });

  static fromMap(Map<String, dynamic> e) {
    return Quest(
      name: e["name"],
      description: e["description"],
      image: e["image"],
      condition: e["condition"].map<String>((e) => e.toString()).toList(),
      conditionDescription: e["conditionDescription"] ?? "",
      rewardId: e["rewardId"],
      rewardType: e["rewardType"],
      point: e["point"] ?? 0,
      id: e["id"],
      state: e["state"] ?? "未完了",
      options: e["options"],
      frequency: e["frequency"],
    );
  }
}
