import 'dart:html';

/// RPGのターン制戦闘システムのコマンドメッセージを表すクラス
/// コマンド仕様:
///   - "first"を最初にキューに入れます。
///   - "end"がpopされたら、戦闘が終了します。
///   - "from"と"to"を使用して、プレイヤーから敵または敵からプレイヤーを識別します。
///   - "attack"と"shield"で値を取り出します。
///   - "BROADCAST"で、前のオブジェクトに通知されます。
///   - "ENEMYS"で敵全体に、"PLAYERS"で全プレイヤーのパーティに通知されます。
///   - 個々のオブジェクトに送信する場合は、それぞれのオブジェクトのIDを "to" プロパティに指定します。
class Messenger {
  Messenger();

  List<Message> messages = [];
  List<Listner> listners = [];

  void sendAllMessage() {
    for (Message message in messages) {
      sendMessage(message);
    }
  }

  // メッセージの送信
  void sendMessage(Message message) {
    for (Listner listner in listners) {
      listner.executeMethod(message);
    }
  }

  // メッセージの登録
  void registerMessage(Message message) {
    messages.add(message);
  }

  // 聴衆の登録
  void registerListner(Listner listner) {
    listners.add(listner);
  }

  // 聴衆の登録解除
  void removeListner(Listner listner) {
    listners.remove(listner);
  }
}

/// 聴衆
class Listner {
  Listner({required this.messenger});

  final Messenger messenger;
  Map<Message, Function> functions = {};

  // メソッドの登録
  void registerMethod(Function func, Message message) {
    functions[message] = func;
  }

  // メソッドの実行
  void executeMethod(Message message) {
    if (functions.containsKey(message)) {
      functions[message]!();
    }
  }

  // メッセージの送信
  void sendMessage(Message message) {
    messenger.registerMessage(message);
  }
}

/// メッセージの構造体
class Message {
  const Message(
      {required this.name,
      required this.from,
      this.to = "BROADCAST",
      required this.data,
      this.option});

  final String name, from, to;
  final dynamic data;
  final dynamic option;
}
