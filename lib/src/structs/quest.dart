// クエスト用のクラス
class Quest {
  Quest({
    required this.name,
    required this.description,
    required this.point,
    required this.id,
  });

  final String name;
  final String description;
  final int point;
  final int id;
  bool done = false;
  dynamic options;

  // 完了にする
  void markAsDone() {
    done = true;
  }

  // 未完了にする
  void markAsUnfinished() {
    done = false;
  }
}
