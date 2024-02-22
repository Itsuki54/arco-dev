import 'package:arco_dev/src/utils/database.dart';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class AutoBattle {
  final String playerUid;
  final String? player2Uid;
  final Database database = Database();
  final List<String> finalResult = [];
  // 敵のドキュメントIDリスト
  final List<String> enemies;

  AutoBattle(this.playerUid, this.player2Uid, this.enemies);

  Future<bool> start() async {
    List<String> result = [];
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
          result += await _win(playerUid, playerCharacters, player2Characters);
          break;
        } else if (playerCharacters.isEmpty) {
          win = false;
          result +=
              await _win(player2Uid!, player2Characters, playerCharacters);
          break;
        }
      } else {
        if (enemyCharacters!.isEmpty) {
          win = true;
          result += await _win(playerUid, playerCharacters, enemyCharacters);
          break;
        }
      }

      if (playerCharacters.isEmpty) {
        win = false;
        break;
      }

      if (player2Uid != null) {
        result += await _battle(playerCharacters, player2Characters!);
      } else {
        result += await _battle(playerCharacters, enemyCharacters!);
      }
    }
    finalResult.addAll(result);
    return win;
  }

  Future<List<String>> _win(String uid, List<Map<String, dynamic>> party,
      List<Map<String, dynamic>> enemies) async {
    List<String> result = [];
    result
        .add("${(await database.usersCollection().findById(uid))["name"]}の勝利！");
    num exp = 0;
    for (int i = 0; i < enemies.length; i++) {
      exp += (enemies[i]['level'] + enemies[i]['rarity'] * 2) * 10;
    }
    await database
        .usersCollection()
        .update(uid, {'exp': FieldValue.increment(exp)});

    for (int i = 0; i < party.length; i++) {
      Map<String, dynamic> character = party[i];
      character['exp'] += exp;
      result.add("${character['name']}は$expの経験値を得た");
      if (character['exp'] >=
          (character['level'] + character['rarity'] * 2) * 15) {
        character['level']++;
        character['exp'] = 0;
        result.add("${character['name']}はレベルが上がった");
      }
      await database
          .userPartyCollection(uid)
          .update(character['id'], character);
    }

    return result;
  }

  Future<List<String>> _battle(List<Map<String, dynamic>> playerCharacters,
      List<Map<String, dynamic>> enemyCharacters) async {
    List<String> result = [];
    Random random = Random();
    for (int i = 0; i < playerCharacters.length; i++) {
      Map<String, dynamic> playerCharacter = playerCharacters[i];
      // 敵キャラクターをランダムに選択
      Map<String, dynamic> enemyCharacter =
          enemyCharacters[random.nextInt(enemyCharacters.length)];
      // アルテリオス計算式
      int playerDamage = (playerCharacter['status']['atk'] *
              playerCharacter['status']['spd']) -
          (enemyCharacter['status']['def'] * enemyCharacter['status']['spd']);
      int enemyDamage = (enemyCharacter['status']['atk'] *
              enemyCharacter['status']['spd']) -
          (playerCharacter['status']['def'] * playerCharacter['status']['spd']);
      if (playerDamage > 0) {
        result.add(
            "${playerCharacter['name']}は${enemyCharacter['name']}に$playerDamageのダメージを与えた");
        enemyCharacter['hp'] -= playerDamage;
      }
      if (enemyDamage > 0) {
        result.add(
            "${enemyCharacter['name']}は${playerCharacter['name']}に$enemyDamageのダメージを与えた");
        playerCharacter['hp'] -= enemyDamage;
      }
      if (enemyCharacter['hp'] <= 0) {
        result.add("${enemyCharacter['name']}は倒れた");
        enemyCharacters.removeAt(i);
      }
      if (playerCharacter['hp'] <= 0) {
        result.add("${playerCharacter['name']}は倒れた");
        playerCharacters.removeAt(i);
      }
    }
    return result;
  }
}
