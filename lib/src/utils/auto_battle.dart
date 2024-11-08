import 'package:arco_dev/src/utils/database.dart';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/*
使い方:
  AutoBattle(uid, 対戦相手のuid)でインスタンスを作成
  isWin = autoBattle.start()
  result = autoBattle.finalResult
*/
class AutoBattle {
  final String playerUid; // プレイヤー
  final String? player2Uid; // 対戦相手
  final Database database = Database();
  final List<String> finalResult = []; // 戦闘結果

  final List<String>? enemies = []; // 敵のドキュメントIDリスト
  List<String> finalExp = []; // 得られる経験値
  List<String> finalParties = [];
  String opponent = "";
  String name = "";
  DateTime endTime = DateTime.now();

  AutoBattle(this.playerUid, this.player2Uid);

  // 戦闘開始
  Future<bool> start() async {
    List<String> result = [];
    bool win = false;
    name = (await database.usersCollection().findById(playerUid))["name"];
    if (player2Uid != null) {
      opponent =
          (await database.usersCollection().findById(player2Uid!))["name"];
    } else {
      if (enemies!.length == 1) {
        opponent =
            (await database.enemiesCollection().findById(enemies![0]))["name"];
      } else {
        opponent =
            "${(await database.enemiesCollection().findById(enemies![0]))["name"]}の群れ";
      }
    }
    final playerParty = await database.userPartyCollection(playerUid).all();
    List<Map<String, dynamic>> playerCharacters = await Future.wait(playerParty
        .map((e) =>
            database.userMembersCollection(playerUid).findById(e["memberId"]))
        .toList());
    List<Map<String, dynamic>>? player2Characters;
    List<Map<String, dynamic>>? enemyCharacters;
    if (player2Uid != null) {
      final player2Party =
          await database.userPartyCollection(player2Uid!).all();
      player2Characters = await Future.wait(player2Party
          .map((e) => database
              .userMembersCollection(player2Uid!)
              .findById(e["memberId"]))
          .toList());
      if (player2Characters.isEmpty) {
        throw Exception('Player2 party is empty');
      }
    } else {
      enemyCharacters = await Future.wait(enemies!
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

  // 戦闘終了処理
  Future<List<String>> _win(String uid, List<Map<String, dynamic>> party,
      List<Map<String, dynamic>> enemies) async {
    List<String> result = [];
    final user = await database.usersCollection().findById(uid);
    result.add("${user["name"]}の勝利！");
    num exp = 0;
    for (int i = 0; i < enemies.length; i++) {
      exp += (enemies[i]['level'] + enemies[i]['rarity'] * 2) * 10;
    }
    await database.usersCollection().update(uid, {
      'exp': FieldValue.increment(exp),
      'winCount': FieldValue.increment(1)
    });
    if (user['exp'] + exp >= user['level'] * 50) {
      await database
          .usersCollection()
          .update(uid, {'level': FieldValue.increment(1)});
      result.add("${user["name"]}はレベルが上がった");
    }
    for (int i = 0; i < party.length; i++) {
      Map<String, dynamic> character = party[i];
      if (character['exp'] == null) {
        character['exp'] = 0;
      }
      character['exp'] += exp;
      finalExp.add(character['exp'].toString());
      result.add("${character['name']}は$expの経験値を得た");
      if (character['exp'] >=
          (character['level'] + character['rarity'] * 2) * 15) {
        character['level']++;
        character['exp'] = 0;
        result.add("${character['name']}はレベルが上がった");
      }
      finalParties.add(character['name']);
      await database
          .userMembersCollection(uid)
          .update(character['id'], character);
    }
    endTime = DateTime.now();
    return result;
  }

  // 1ターン分の戦闘
  Future<List<String>> _battle(List<Map<String, dynamic>> playerCharacters,
      List<Map<String, dynamic>> enemyCharacters) async {
    List<String> result = [];
    Random random = Random();
    for (int i = 0; i < playerCharacters.length; i++) {
      Map<String, dynamic> playerCharacter = playerCharacters[i];

      // 敵キャラクターをランダムに選択
      int enemyIndex = 0;
      if (enemyCharacters.length > 1) {
        enemyIndex = random.nextInt(enemyCharacters.length);
      }

      Map<String, dynamic> enemyCharacter = enemyCharacters[enemyIndex];

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
        enemyCharacter['status']['hp'] -= playerDamage;
      }
      if (enemyDamage > 0) {
        result.add(
            "${enemyCharacter['name']}は${playerCharacter['name']}に$enemyDamageのダメージを与えた");
        playerCharacter['status']['hp'] -= enemyDamage;
      }
      if (enemyCharacter['status']['hp'] <= 0) {
        result.add("${enemyCharacter['name']}は倒れた");
        enemyCharacters.removeAt(enemyIndex);
      }
      if (playerCharacter['status']['hp'] <= 0) {
        result.add("${playerCharacter['name']}は倒れた");
        playerCharacters.removeAt(i);
      }
    }
    return result;
  }
}
