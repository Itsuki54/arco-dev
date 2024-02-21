import 'package:cloud_firestore/cloud_firestore.dart';

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
    final data = doc.data();
    return data as Map<String, dynamic>;
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
      return getDataFromDocumentData(doc);
    });
  }

  Future<List<Map<String, dynamic>>> all() async {
    final snapshot = await collection.get();
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

class UsersCollection extends BaseCollection {
  UsersCollection(FirebaseFirestore firestore) : super('USERS', firestore);

  Future<void> createUser(String uid, Map<String, dynamic> data) {
    set(uid, data);
    return UserQuestsCollection(firestore, uid).copyFromQuestsCollection(uid);
  }
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

  Future<void> copyFromQuestsCollection(String uid) {
    return QuestsCollection(firestore).all().then((quests) {
      for (var quest in quests) {
        set(quest['questId'], {
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
