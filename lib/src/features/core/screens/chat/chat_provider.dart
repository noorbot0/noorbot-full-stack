import 'dart:convert';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:noorbot_app/src/constants/apis.dart';
import 'package:noorbot_app/src/constants/firestore_constants.dart';
import 'package:noorbot_app/src/features/core/models/chat/analysis.dart';
import 'package:noorbot_app/src/features/core/models/chat/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatProvider {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  final openAI = OpenAI.instance.build(
      token: GPTAPIs.keyToken,
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 20)),
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

  void chatComplete(
      List<Map<String, String>> msgs,
      String currentUserId,
      String chatId,
      String content,
      Function callback,
      Function errCallback) async {
    String time = storeMessage(
        currentUserId, chatId, content, FirestoreConstants.userRole);
    void analyserCallBack(String resp) {
      updateMessage(currentUserId, chatId, time, content, resp,
          FirestoreConstants.userRole);
    }

    messageAnalysis(content, currentUserId, chatId, analyserCallBack);
    final request = ChatCompleteText(
        messages: msgs, maxToken: 300, model: ChatModel.gptTurbo);
    ChatCTResponse? response;
    try {
      response = await openAI.onChatCompletion(request: request);
    } catch (e) {
      errCallback(e.toString());
    }
    String? firstRes = "";
    for (var element in response!.choices) {
      firstRes = element.message?.content;
    }
    storeMessage(currentUserId, chatId, firstRes!, FirestoreConstants.aiRole);
    callback(firstRes);
  }

  void messageAnalysis(String message, String currentUserId, String chatId,
      Function callback) async {
    // storeMessage(currentUserId, chatId, content, FirestoreConstants.userRole);
    String prpt =
        "Classify whether a sentence's sentiment is positive, neutral, or negative.\n\n$message\n";
    // String prpt = "Classify the sentiment in these tweets:\n\n$message\n";
    final request = CompleteText(
        model: Model.textDavinci3,
        prompt: prpt,
        temperature: 0,
        maxTokens: 60,
        topP: 1.0,
        frequencyPenalty: 0.0,
        presencePenalty: 0.0);

    final response = await openAI.onCompletion(request: request);

    String? res = "";
    for (var element in response!.choices) {
      res = element.text;
    }
    updateAnalysis(currentUserId, chatId, res!);
    // storeMessage(currentUserId, chatId, res!, FirestoreConstants.aiRole);
    // print("callling back-----------------------");
    callback(res.trim());
  }

  String storeMessage(
      String currentUserId, String chatId, String content, String role) {
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    DocumentReference documentReference = firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(chatId)
        .collection(FirestoreConstants.conv)
        .doc(time);

    MessageChat messageChat = MessageChat(
        idFrom: currentUserId,
        timestamp: time,
        content: content,
        role: role,
        sentiment: "-");

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        messageChat.toJson(),
      );
    });

    return time;
  }

  void updateMessage(String currentUserId, String chatId, String time,
      String content, String sentiment, String role) {
    DocumentReference documentReference = firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(chatId)
        .collection(FirestoreConstants.conv)
        .doc(time);

    MessageChat messageChat = MessageChat(
        idFrom: currentUserId,
        timestamp: time,
        content: content,
        role: role,
        sentiment: sentiment);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        messageChat.toJson(),
      );
    });
  }

  void updateAnalysis(
      String currentUserId, String chatId, String sentiment) async {
    DateTime now = DateTime.now().toUtc();
    String time = DateFormat("MM_dd_yyyy").format(now);
    DocumentReference documentReference = firebaseFirestore
        .collection(FirestoreConstants.pathAnalysisCollection)
        .doc(chatId)
        .collection(FirestoreConstants.sentiment)
        .doc(time);
    Analysis analysis = Analysis(
        idFrom: currentUserId,
        date: time,
        messagesNumber: 1,
        sentimentNegative: 0,
        sentimentNeutral: 0,
        sentimentPositive: 0,
        sentimentNone: 0);
    try {
      documentReference.get().then((DocumentSnapshot doc) {
        if (doc.exists) {
          analysis.messagesNumber = doc[FirestoreConstants.messagesNumber] + 1;
          if (sentiment.contains(FirestoreConstants.sentimentNegative)) {
            analysis.sentimentNegative =
                doc[FirestoreConstants.sentimentNegative] + 1;
          } else if (sentiment.contains(FirestoreConstants.sentimentPositive)) {
            analysis.sentimentPositive =
                doc[FirestoreConstants.sentimentPositive] + 1;
          } else if (sentiment.contains(FirestoreConstants.sentimentNeutral)) {
            analysis.sentimentNeutral =
                doc[FirestoreConstants.sentimentNeutral] + 1;
          } else {
            analysis.sentimentNone = doc[FirestoreConstants.sentimentNone] + 1;
          }
        }
        FirebaseFirestore.instance.runTransaction((transaction) async {
          transaction.set(
            documentReference,
            analysis.toJson(),
          );
        });
      });
    } catch (e) {
      print(e);
    }
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
