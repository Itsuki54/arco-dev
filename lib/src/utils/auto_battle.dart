import 'package:arco_dev/src/utils/database.dart';
import 'dart:math';

class AutoBattle {
  final String playerUid;
  final String? player2Uid;
  final Database database = Database();
  // 敵のドキュメントIDリスト
  final List<String> enemies;

  AutoBattle(this.playerUid, this.player2Uid, this.enemies);

  Future<bool> start() async {
    bool win = false;
    List<Map<String, dynamic>> playerCharacters =
        await database.userPartyCollection(playerUid).all();
    List<Map<String, dynamic>>? player2Characters;
    List<Map<String, dynamic>>? enemyCharacters;
    if (player2Uid != null) {
      player2Characters = await database.userPartyCollection(player2Uid!).all();
      if (player2Characters.isEmpty) {
        throw Exception('Player2 party is empty');
      }
    } else {
      enemyCharacters = await Future.wait(enemies
          .map((e) => database.enemiesCollection().findById(e))
          .toList());
      if (enemyCharacters.isEmpty) {
        throw Exception('Enemy party is empty');
      }
    }

    while (true) {
      if (player2Uid != null) {
        if (player2Characters!.isEmpty) {
          win = true;
          break;
        }
      } else {
        if (enemyCharacters!.isEmpty) {
          win = true;
          break;
        }
      }

      if (playerCharacters.isEmpty) {
        win = false;
        break;
      }

      if (player2Uid != null) {
        await _battle(playerCharacters, player2Characters!);
      } else {
        await _battle(playerCharacters, enemyCharacters!);
      }
    }

    return win;
  }

  Future<void> _battle(List<Map<String, dynamic>> playerCharacters,
      List<Map<String, dynamic>> enemyCharacters) async {
    Random random = Random();
    for (int i = 0; i < playerCharacters.length; i++) {
      Map<String, dynamic> playerCharacter = playerCharacters[i];
      // 敵キャラクターをランダムに選択
      Map<String, dynamic> enemyCharacter =
          enemyCharacters[random.nextInt(enemyCharacters.length)];
      // アルテリオス計算式
      int playerDamage =
          playerCharacter['status']['atk'] - enemyCharacter['status']['def'];
      int enemyDamage =
          enemyCharacter['status']['atk'] - playerCharacter['status']['def'];
      if (playerDamage > 0) {
        enemyCharacter['hp'] -= playerDamage;
      }
      if (enemyDamage > 0) {
        playerCharacter['hp'] -= enemyDamage;
      }
      if (enemyCharacter['hp'] <= 0) {
        enemyCharacters.removeAt(i);
      }
      if (playerCharacter['hp'] <= 0) {
        playerCharacters.removeAt(i);
      }
    }
  }
}
