// クエスト用のクラス
class Quest {
  Quest({
    required this.name,
    required this.description,
    required this.point,
    required this.id,
    this.state = "未完了",
  });

  final String name;
  final String description;
  final int point;
  final int id;
  final String state;
  dynamic options;
}
