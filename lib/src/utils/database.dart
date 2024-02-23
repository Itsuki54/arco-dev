import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class BaseCollection {
  final String ref;
  final FirebaseFirestore firestore;

  BaseCollection(this.ref, this.firestore);

  CollectionReference<Map<String, dynamic>> get collection {
    return firestore.collection(ref);
  }

  Future<DocumentReference<Map<String, dynamic>>> add(
      Map<String, dynamic> data) {
    return collection.add(data);
  }

  Map<String, dynamic> getDataFromDocumentData(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    data["id"] = doc.id;
    return data;
  }

  Future<void> set(String id, Map<String, dynamic> data) {
    return collection.doc(id).set(data);
  }

  Future<void> update(String id, Map<String, dynamic> data) {
    return collection.doc(id).update(data);
  }

  Future<void> delete(String id) {
    return collection.doc(id).delete();
  }

  Future<Map<String, dynamic>> findById(String id) {
    return collection.doc(id).get().then((doc) {
      if (doc.exists) {
        return getDataFromDocumentData(doc);
      } else {
        return {};
      }
    });
  }

  Future<List<Map<String, dynamic>>> all() async {
    final snapshot = await collection.get();
    return snapshot.docs.map((doc) {
      return getDataFromDocumentData(doc);
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getByOrder(
      String field, bool descending) async {
    Query<Map<String, dynamic>> ref = collection;
    ref = ref.orderBy(field, descending: descending);
    final snapshot = await ref.get();
    return snapshot.docs.map((doc) {
      return getDataFromDocumentData(doc);
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getByQuery(
      Map<String, dynamic> query) async {
    Query<Map<String, dynamic>> ref = collection;
    switch (query['type']) {
      case 'isEqualTo':
        ref = ref.where(query['field'], isEqualTo: query['value']);
        break;
      case 'isNotEqualTo':
        ref = ref.where(query['field'], isNotEqualTo: query['value']);
        break;
      case 'isGreaterThan':
        ref = ref.where(query['field'], isGreaterThan: query['value']);
        break;
      case 'isGreaterThanOrEqualTo':
        ref = ref.where(query['field'], isGreaterThanOrEqualTo: query['value']);
        break;
      case 'isLessThan':
        ref = ref.where(query['field'], isLessThan: query['value']);
        break;
      case 'isLessThanOrEqualTo':
        ref = ref.where(query['field'], isLessThanOrEqualTo: query['value']);
        break;
      case 'arrayContains':
        ref = ref.where(query['field'], arrayContains: query['value']);
        break;
      case 'arrayContainsAny':
        ref = ref.where(query['field'], arrayContainsAny: query['value']);
        break;
      case 'whereIn':
        ref = ref.where(query['field'], whereIn: query['value']);
        break;
      case 'whereNotIn':
        ref = ref.where(query['field'], whereNotIn: query['value']);
        break;
      case 'isNull':
        ref = ref.where(query['field'], isNull: query['value']);
        break;
      default:
        break;
    }
    final snapshot = await ref.get();
    return snapshot.docs.map((doc) {
      return getDataFromDocumentData(doc);
    }).toList();
  }

  Future<Map<String, dynamic>> getRandomDoc(String? attribute) async {
    List<Map<String, dynamic>> allData = [];
    if (attribute != null && attribute.isNotEmpty) {
      allData = await getByQuery(
          {'type': 'isEqualTo', 'field': 'attribute', 'value': attribute});
    } else {
      allData = await all();
    }
    int length = allData.length;
    int rand = Random().nextInt(length);
    return allData[rand];
  }
}

class CharactersCollection extends BaseCollection {
  CharactersCollection(FirebaseFirestore firestore)
      : super('CHARACTERS', firestore);
}

class ItemsCollection extends BaseCollection {
  ItemsCollection(FirebaseFirestore firestore) : super('ITEMS', firestore);
}

class EnemiesCollection extends BaseCollection {
  EnemiesCollection(FirebaseFirestore firestore) : super('ENEMIES', firestore);
}

class QuestsCollection extends BaseCollection {
  QuestsCollection(FirebaseFirestore firestore) : super('QUESTS', firestore);
}

class WeaponsCollection extends BaseCollection {
  WeaponsCollection(FirebaseFirestore firestore) : super('WEAPONS', firestore);
}

class UsersCollection extends BaseCollection {
  UsersCollection(FirebaseFirestore firestore) : super('USERS', firestore);

  Future<void> createUser(String uid, Map<String, dynamic> data) {
    set(uid, data);
    return UserQuestsCollection(firestore, uid).copyFromQuestsCollection();
  }

  doc(String uid) {}
}

class UserItemsCollection extends BaseCollection {
  UserItemsCollection(FirebaseFirestore firestore, String uid)
      : super('USERS/$uid/ITEMS', firestore);
}

class UserMembersCollection extends BaseCollection {
  UserMembersCollection(FirebaseFirestore firestore, String uid)
      : super('USERS/$uid/MEMBERS', firestore);
}

class UserQuestsCollection extends BaseCollection {
  UserQuestsCollection(FirebaseFirestore firestore, String uid)
      : super('USERS/$uid/QUESTS', firestore);

  Future<void> copyFromQuestsCollection() {
    return QuestsCollection(firestore).all().then((quests) {
      for (var quest in quests) {
        set(quest["id"], {
          'frequency': quest['frequency'],
          'questId': quest['questId'],
          'image': quest['image'],
          'name': quest['name'],
          'description': quest['description'],
          'condition': quest['condition'],
          'conditionDetail': quest['conditionDetail'],
          'rewardId': quest['rewardId'],
          'rewardType': quest['rewardType'],
          'state': quest['state'],
        });
      }
    });
  }

  Future<void> copyDailyQuestsFromQuestsCollection() {
    return QuestsCollection(firestore).getByQuery({
      'type': 'isEqualTo',
      'field': 'frequency',
      'value': 'daily'
    }).then((quests) {
      for (var quest in quests) {
        set(quest['id'], {
          'frequency': 'daily',
          'questId': quest['questId'],
          'image': quest['image'],
          'name': quest['name'],
          'description': quest['description'],
          'condition': quest['condition'],
          'conditionDetail': quest['conditionDetail'],
          'rewardId': quest['rewardId'],
          'rewardType': quest['rewardType'],
          'state': quest['state'],
        });
      }
    });
  }

  Future<void> copyWeeklyQuestsFromQuestsCollection(String uid) {
    return QuestsCollection(firestore).getByQuery({
      'type': 'isEqualTo',
      'field': 'frequency',
      'value': 'weekly'
    }).then((quests) {
      for (var quest in quests) {
        set(quest['id'], {
          'frequency': 'weekly',
          'questId': quest['questId'],
          'image': quest['image'],
          'name': quest['name'],
          'description': quest['description'],
          'condition': quest['condition'],
          'conditionDetail': quest['conditionDetail'],
          'rewardId': quest['rewardId'],
          'rewardType': quest['rewardType'],
          'state': quest['state'],
        });
      }
    });
  }
}

class UserWeaponsCollection extends BaseCollection {
  UserWeaponsCollection(FirebaseFirestore firestore, String uid)
      : super('USERS/$uid/WEAPONS', firestore);
}

class UserHealthCollection extends BaseCollection {
  UserHealthCollection(FirebaseFirestore firestore, String uid)
      : super('USERS/$uid/HEALTH', firestore);
}

class UserPartyCollection extends BaseCollection {
  UserPartyCollection(FirebaseFirestore firestore, String uid)
      : super('USERS/$uid/PARTY', firestore);
}

class Database {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CharactersCollection charactersCollection() {
    return CharactersCollection(firestore);
  }

  ItemsCollection itemsCollection() {
    return ItemsCollection(firestore);
  }

  EnemiesCollection enemiesCollection() {
    return EnemiesCollection(firestore);
  }

  QuestsCollection questsCollection() {
    return QuestsCollection(firestore);
  }

  WeaponsCollection weaponsCollection() {
    return WeaponsCollection(firestore);
  }

  UsersCollection usersCollection() {
    return UsersCollection(firestore);
  }

  UserItemsCollection userItemsCollection(String uid) {
    return UserItemsCollection(firestore, uid);
  }

  UserMembersCollection userMembersCollection(String uid) {
    return UserMembersCollection(firestore, uid);
  }

  UserQuestsCollection userQuestsCollection(String uid) {
    return UserQuestsCollection(firestore, uid);
  }

  UserWeaponsCollection userWeaponsCollection(String uid) {
    return UserWeaponsCollection(firestore, uid);
  }

  UserHealthCollection userHealthCollection(String uid) {
    return UserHealthCollection(firestore, uid);
  }

  UserPartyCollection userPartyCollection(String uid) {
    return UserPartyCollection(firestore, uid);
  }
}
