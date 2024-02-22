import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class BaseStorage {
  final String ref;
  final FirebaseStorage storage;

  BaseStorage(this.ref, this.storage);

  Reference get reference {
    return storage.ref(ref);
  }

  Future<String> upload(String path, String name) async {
    final ref = reference.child(name);
    await ref.putFile(File(path));
    return ref.getDownloadURL();
  }

  Future<String> uploadBytes(List<int> bytes, String name) async {
    final ref = reference.child(name);
    await ref.putData(Uint8List.fromList(bytes));
    return ref.getDownloadURL();
  }

  Future<String> getUrl(String name) async {
    final ref = reference.child(name);
    return ref.getDownloadURL();
  }

  Future<void> delete(String name) async {
    final ref = reference.child(name);
    await ref.delete();
  }
}

class CharacterIconsStorage extends BaseStorage {
  CharacterIconsStorage(FirebaseStorage storage)
      : super('CHARACTER_ICONS', storage);
}

class ItemIconsStorage extends BaseStorage {
  ItemIconsStorage(FirebaseStorage storage) : super('ITEM_ICONS', storage);
}

class QuestIconsStorage extends BaseStorage {
  QuestIconsStorage(FirebaseStorage storage) : super('QUEST_ICONS', storage);
}

class WeaponIconsStorage extends BaseStorage {
  WeaponIconsStorage(FirebaseStorage storage) : super('WEAPON_ICONS', storage);
}

class UsersStorage extends BaseStorage {
  UsersStorage(FirebaseStorage storage) : super('USERS/ICONS', storage);
}

class Storage {
  final FirebaseStorage storage = FirebaseStorage.instance;

  CharacterIconsStorage characterIcons() {
    return CharacterIconsStorage(storage);
  }

  ItemIconsStorage itemIcons() {
    return ItemIconsStorage(storage);
  }

  QuestIconsStorage questIcons() {
    return QuestIconsStorage(storage);
  }

  WeaponIconsStorage weaponIcons() {
    return WeaponIconsStorage(storage);
  }

  UsersStorage users() {
    return UsersStorage(storage);
  }
}
