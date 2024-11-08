import 'package:arco_dev/src/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key, required this.uid});

  final String uid;

  @override
  State<ShopPage> createState() => _ShopPage();
}

class _ShopPage extends State<ShopPage> {
  List<Map<String, dynamic>> foods = [];
  List<Map<String, dynamic>> weapons = [];
  List<Map<String, dynamic>> services = [];
  List<Map<String, dynamic>> items = [
    {
      "description": "収穫されたばかりの泥付きにんじん。ぷっくりしていて、甘みがある。地産地消は大事ですね。",
      "name": "泥付きの人参",
      "image": "ITEM_ICONS/Callot.png",
      "attribute": "food",
      "avility": {"heal": 10, "attack": 20, "defence": 10}
    },
    {
      "description":
          "もう廃線になってしまった路線で使われていた、幻の切符。マニア争奪戦になっており、インターネットオークションにおいて高値で取引されている",
      "name": "廃線の切符",
      "image": "ITEM_ICONS/Ticket.png",
      "attribute": "public",
      "avility": {"heal": 0, "attack": 10, "defence": 0}
    },
    {
      "description":
          "日曜発明家が発明家が、払い下げの消防車を改造した。ポンプの威力は強力で、炎ごとビルが吹き飛ぶという。最近、土木工事で使用されている。",
      "name": "消防車(改)",
      "image": "ITEM_ICONS/FireTruck.png",
      "attribute": "public",
      "avility": {"heal": 0, "attack": 30, "defence": 5}
    },
    {
      "description": "おしゃれに気を遣う巡査が作った。金メッキの刺々しい見た目で、腰にさげている様は昔の侍のよう。",
      "name": "いかつい手錠",
      "image": "ITEM_ICONS/Catch.png",
      "attribute": "public",
      "avility": {"heal": 0, "attack": 20, "defence": 0}
    },
    {
      "description": "見た目は単四電池だが、その威力は凄まじい。そのパワーからか、誰も本品に近づけず、一種の聖域となって奉られている。",
      "name": "100万ボルト",
      "image": "ITEM_ICONS/Volt.png",
      "attribute": "service",
      "avility": {"heal": 0, "attack": 20, "defence": 0}
    },
    {
      "description": "使うのが難しいハサミ。右利きでも左利きでもない、第三の手の持ち主が使っていた。",
      "name": "難しいハサミ",
      "image": "ITEM_ICONS/Scissors.png",
      "attribute": "service",
      "avility": {"heal": 0, "attack": 10, "defence": 0}
    },
    {
      "description":
          "睡眠不足だった仏様のために、元脳科学者の住職がが考案した。よく眠れると評判で、ストリーミングでの再生回数が好調である。",
      "name": "ねむたいお経",
      "image": "ITEM_ICONS/Okyo.png",
      "attribute": "nature",
      "avility": {"heal": 15, "attack": 15, "defence": 15}
    },
    {
      "description": "印刷局の手違いで、金属板に印刷されてしまった札束。ビンタされるとけっこう痛い。",
      "name": "硬い札束",
      "image": "ITEM_ICONS/Satu.png",
      "attribute": "service",
      "avility": {"heal": 0, "attack": 100, "defence": 0}
    },
    {
      "description": "プロテインはプロテイン。",
      "name": "プロテイン",
      "image": "ITEM_ICONS/Protein.png",
      "attribute": "food",
      "avility": {"heal": 5, "attack": 5, "defence": 10}
    },
    {
      "description": "本来叩くべきではないものを叩いてきたらしいハンマー。錆びているだけだと信じたい。",
      "name": "真っ赤なハンマー",
      "image": "ITEM_ICONS/Hunmer.png",
      "attribute": "service",
      "avility": {"heal": 0, "attack": 30, "defence": 0}
    },
    {
      "description": "裁判長がコンコン叩くあれ。みんな静粛になる。",
      "name": "ガベル",
      "image": "ITEM_ICONS/Gabel.png",
      "attribute": "public",
      "avility": {"heal": 0, "attack": 10, "defence": 10}
    },
    {
      "description": "コッペパン、牛乳、茹でサラダにトンカツ。ソースはクラスに一本ずつ。",
      "name": "懐かしい給食",
      "image": "ITEM_ICONS/Lunch.png",
      "attribute": "food",
      "avility": {"heal": 15, "attack": 0, "defence": 10}
    },
    {
      "description": "封筒に貼ると、風に乗って勝手に運ばれていく。その性質上、速達より早く届くが、天候に気を付ける必要がある。",
      "name": "風の切手",
      "image": "ITEM_ICONS/Kitte.png",
      "attribute": "public",
      "avility": {"heal": 0, "attack": 10, "defence": 10}
    },
    {
      "description": "流線形のボディ。光り輝く塗装。銀メッキのエンブレム。",
      "name": "かっこいい車",
      "image": "ITEM_ICONS/Car.png",
      "attribute": "service",
      "avility": {"heal": 0, "attack": 30, "defence": 10}
    },
    {
      "description": "昔使われていた旅客機。改造して家にすると楽しそう。",
      "name": "ジェット機",
      "image": "ITEM_ICONS/Jet.png",
      "attribute": "service",
      "avility": {"heal": 20, "attack": 35, "defence": 30}
    },
    {
      "description": "ハンコをいっぱい押せる証明書",
      "name": "証明書",
      "image": "ITEM_ICONS/Certificate.png",
      "attribute": "public",
      "avility": {"heal": 0, "attack": 0, "defence": 15}
    },
    {
      "description": "こげた砂糖の苦味と甘み",
      "name": "カラメルポップコーン",
      "image": "ITEM_ICONS/Popcorn.png",
      "attribute": "food",
      "avility": {"heal": 10, "attack": 5, "defence": 0}
    },
    {
      "description": "魔法学校から帰省してきた小学生のノート。不思議な文字で溢れている。",
      "name": "魔導書",
      "image": "ITEM_ICONS/Magic.png",
      "attribute": "nature",
      "avility": {"heal": 20, "attack": 30, "defence": 10}
    },
    {
      "description": "ぱりぱりの海苔が巻いてある。シャケとイクラとタラコの爆弾おにぎり。",
      "name": "爆弾おにぎり",
      "image": "ITEM_ICONS/Rice.png",
      "attribute": "food",
      "avility": {"heal": 15, "attack": 0, "defence": 0}
    },
    {
      "description": "海賊らしい、にくにくしたバイキング。野菜はオレンジジュースだけ。",
      "name": "海賊バイキング",
      "image": "ITEM_ICONS/Viking.png",
      "attribute": "food",
      "avility": {"heal": 50, "attack": 0, "defence": 0}
    },
    {
      "description": "なんでも治る。たぶん大丈夫な薬",
      "name": "薬",
      "image": "ITEM_ICONS/Drag.png",
      "attribute": "nature",
      "avility": {"heal": 50, "attack": 0, "defence": 10}
    },
    {
      "description": "店主が手ゴネしたハンバーグ。赤身がおいしい。",
      "name": "あつあつハンバーグ",
      "image": "ITEM_ICONS/meet.png",
      "attribute": "food",
      "avility": {"heal": 30, "attack": 0, "defence": 10}
    },
    {
      "description": "南洋の島で採れたバナナ。その祖先は、海を伝って浜辺に流れ着いたという。",
      "name": "ふっくらバナナ",
      "image": "ITEM_ICONS/Banana.png",
      "attribute": "food",
      "avility": {"heal": 15, "attack": 10, "defence": 10}
    },
    {
      "description": "金の豆と言われた希少な豆をブレンドした。一口飲めば、しゃっきりした気分になる。深みが良い。",
      "name": "ブレンドコーヒー",
      "image": "ITEM_ICONS/Coffee.png",
      "attribute": "food",
      "avility": {"heal": 20, "attack": 5, "defence": 5}
    }
  ];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < items.length; i++) {
      switch (items[i]['attribute']) {
        case 'food':
          foods.add(items[i]);
        case 'public':
          weapons.add(items[i]);
        default:
          services.add(items[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text('Shop',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            Icon(Icons.storefront, size: 42),
          ]),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                  icon: Icon(Icons.category_rounded, size: 29),
                  child: Text("Items",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              //Tab(
              //    icon: Icon(Icons.build, size: 29),
              //    child: Text("Wepons",
              //        style: TextStyle(fontWeight: FontWeight.bold))),
              //Tab(
              //    icon: Icon(Icons.support_agent, size: 29),
              //    child: Text("Services",
              //        style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            SingleChildScrollView(
                child: Column(
              children: [
                const SizedBox(height: 16),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  for (int i = 0; i < items.length; i++)
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          showDialog<void>(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(items[i]['name'],
                                            style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold))
                                      ]),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.category_rounded,
                                          size: 125),
                                      const SizedBox(height: 32),
                                      Text(items[i]['description'],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.orange),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: SizedBox(
                                              width: 200,
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${(i + 1) * 100}point で購入する",
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    )
                                                  ]))),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.indigo),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const SizedBox(
                                              width: 200,
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "閉じる",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    )
                                                  ]))),
                                    ],
                                  ),
                                );
                              });
                        },
                        child: SizedBox(
                            width: 110,
                            height: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(Icons.category_rounded, size: 72),
                                const SizedBox(height: 20),
                                Text(
                                  items[i]['name'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                              ],
                            )))
                ])
              ],
            )),
            /*SingleChildScrollView(
                child: Column(
              children: [
                const SizedBox(height: 16),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  for (int i = 0; i < 12; i++)
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {},
                        child: const SizedBox(
                            width: 110,
                            height: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.category, size: 72),
                                SizedBox(height: 20),
                                Text(
                                  "アイテム名",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                              ],
                            )))
                ])
              ],
            )),
            SingleChildScrollView(
                child: Column(
              children: [
                const SizedBox(height: 16),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  for (int i = 0; i < 12; i++)
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {},
                        child: const SizedBox(
                            width: 110,
                            height: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.category, size: 72),
                                SizedBox(height: 20),
                                Text(
                                  "アイテム名",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                              ],
                            )))
                ])
              ],
            )),*/
          ],
        ),
      ),
    );
  }
}
