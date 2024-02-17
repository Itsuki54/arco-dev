// 必要なFirebaseモジュールをインポート
import { initializeApp } from "firebase/app";
import { getFirestore, doc, setDoc } from "firebase/firestore";
import { firebaseConfig } from "./firebase.config";
import characters from "./dataSet/Characters.json";
import enemies from "./dataSet/Enemies.json";
import items from "./dataSet/Items.json";
import quest from "./dataSet/Quests.json";

// Firebaseアプリを構成情報で初期化
const app = initializeApp(firebaseConfig);

// Firestoreのインスタンスを取得
const firestore = getFirestore(app);

// Firestoreにデータを追加する関数
const addDataToFirestore = async (collectionPath, documentPath, jsonData) => {
  const docRef = doc(firestore, collectionPath, documentPath);

  try {
    await setDoc(docRef, jsonData);
    console.log(`Firestoreにデータが正常に書き込まれました (${documentPath})`);
  } catch (error) {
    console.error(`Firestoreへの書き込みエラー (${documentPath})`, error);
  }
};

// Firestoreにデータを追加
addDataToFirestore("charactersCollection", "charactersDocument", characters);
addDataToFirestore("enemiesCollection", "enemiesDocument", enemies);
addDataToFirestore("itemsCollection", "itemsDocument", items);
addDataToFirestore("questsCollection", "questsDocument", quest);
