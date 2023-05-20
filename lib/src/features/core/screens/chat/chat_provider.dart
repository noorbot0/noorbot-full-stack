import 'dart:convert';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:noorbot_app/src/constants/apis.dart';
import 'package:noorbot_app/src/constants/firestore_constants.dart';
import 'package:noorbot_app/src/features/core/models/chat/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatProvider {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  final openAI = OpenAI.instance.build(
      token: GPTAPIs.keyToken,
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 10)),
      isLog: true);

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
        .collection(FirestoreConstants.conv)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .limit(limit)
        .snapshots();
  }

  Future<void> chatter(String currentUserId, String chatId, String content,
      Function callback) async {
    storeMessage(currentUserId, chatId, content, FirestoreConstants.userRole);
    http.Response res = await http.post(
      Uri.parse(GCloudAPIs.parlaiRespond),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'message': content,
      }),
    );
    final Map parsed = json.decode(res.body);
    storeMessage(
        currentUserId, chatId, parsed["response"], FirestoreConstants.aiRole);
    callback(parsed);
  }

  void chatComplete(List<Map<String, String>> msgs, String currentUserId,
      String chatId, String content, Function callback) async {
    storeMessage(currentUserId, chatId, content, FirestoreConstants.userRole);
    final request = ChatCompleteText(
        messages: msgs, maxToken: 200, model: ChatModel.gptTurbo);

    final response = await openAI.onChatCompletion(request: request);
    String? firstRes = "";
    print(response);
    for (var element in response!.choices) {
      firstRes = element.message?.content;
      print("data -> ${element.message?.content}");
    }
    storeMessage(currentUserId, chatId, firstRes!, FirestoreConstants.aiRole);
    print("callling back-----------------------");
    callback(firstRes);
  }

  void storeMessage(
      String currentUserId, String chatId, String content, String role) {
    DocumentReference documentReference = firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(chatId)
        .collection(FirestoreConstants.conv)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    MessageChat messageChat = MessageChat(
      idFrom: currentUserId,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      role: role,
    );

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        messageChat.toJson(),
      );
    });
  }

  Future<void> getFirst(
      String currentUserId, String chatId, Function callback) async {
    http.Response res = await http.get(Uri.parse(GCloudAPIs.parlaiGreet));
    final Map parsed = json.decode(res.body);
    storeMessage(
        currentUserId, chatId, parsed["response"], FirestoreConstants.aiRole);
    callback(parsed);
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
