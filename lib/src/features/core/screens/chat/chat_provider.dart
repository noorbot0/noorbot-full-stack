import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:noorbot_app/src/constants/firestore_constants.dart';
import 'package:noorbot_app/src/features/core/models/chat/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatProvider {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  ChatProvider(
      {required this.firebaseFirestore,
      required this.prefs,
      required this.firebaseStorage});

  String? getPref(String key) {
    return prefs.getString(key);
  }

  Future<void> updateDataFirestore(String collectionPath, String docPath,
      Map<String, dynamic> dataNeedUpdate) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(docPath)
        .update(dataNeedUpdate);
  }

  Stream<QuerySnapshot> getChatStream(String chatId, int limit) {
    return firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(chatId)
        .collection("conv")
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .limit(limit)
        .snapshots();
  }

  Future<void> chatter(String currentUserId, String chatId, String content,
      Function callback) async {
    storeMessage(currentUserId, chatId, content, 1);
    http.Response res = await http.post(
      Uri.parse('https://noorbot-app.web.app/grs'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'message': content,
      }),
    );
    final Map parsed = json.decode(res.body);
    storeMessage(currentUserId, chatId, parsed["response"], 0);
    callback(parsed);
  }

  void storeMessage(
      String currentUserId, String chatId, String content, int sender) {
    DocumentReference documentReference = firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(chatId)
        .collection("conv")
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    MessageChat messageChat = MessageChat(
      idFrom: currentUserId,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      sender: sender,
    );

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        messageChat.toJson(),
      );
    });
  }

  // Future<void> chatGCFunction(String currentUserId, String groupChatId,
  //     String content, Function okCallback, Function errCallback) async {
  //   try {
  //     final result =
  //         await FirebaseFunctions.instance.httpsCallable('res').call({
  //       "message": content,
  //       "push": true,
  //     });
  //     print(result.data as String);
  //     // okCallback(result.data as String);
  //   } on FirebaseFunctionsException {
  //     // print(error.code);
  //     // print(error.details);
  //     // print(error.message);
  //     // errCallback(error);
  //   }
  // }
}
