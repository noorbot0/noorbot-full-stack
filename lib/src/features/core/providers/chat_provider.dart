import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:noorbot_app/src/constants/apis.dart';
import 'package:noorbot_app/src/constants/firestore_constants.dart';
import 'package:noorbot_app/src/features/core/models/chat/analysis.dart';
import 'package:noorbot_app/src/features/core/models/chat/chat.dart';
import 'package:noorbot_app/src/features/core/providers/logger_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatProvider {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  late final LoggerProvider log;

  ChatProvider(
      {required this.firebaseFirestore,
      required this.prefs,
      required this.firebaseStorage}) {
    log = LoggerProvider(prefs: prefs);
  }

  String? getPref(String key) {
    return prefs.getString(key);
  }

  Future<void> updateDataFirestore(String collectionPath, String docPath,
      Map<String, dynamic> dataNeedUpdate) {
    log.info(
        "Update collection($collectionPath/$docPath) with data($dataNeedUpdate)");

    return firebaseFirestore
        .collection(collectionPath)
        .doc(docPath)
        .update(dataNeedUpdate);
  }

  Stream<QuerySnapshot> getChatStream(String chatId, int limit) {
    log.info("Getting chat stream for chatId($chatId) with limit ($limit)");
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

  String storeMessage(
      String currentUserId, String chatId, String content, String role) {
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    log.info(
        "Storing message($content) for chatId($chatId) by role ($role) at time($time)");
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
    log.info(
        "Update message($content) for chatId($chatId) by role ($role) at time($time), with sentiment($sentiment)");
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
    String currentUserId,
    String chatId,
    String sentiment,
    List<String> sentiments,
    Function errorCallback,
  ) async {
    // updateAnalysisRandom(currentUserId, chatId, sentiment);
    DateTime now = DateTime.now();
    String time = DateFormat("MM_dd_yyyy").format(now);
    log.info("Storing analysis($sentiment) for chatId($chatId) at time($time)");
    DocumentReference documentReference = firebaseFirestore
        .collection(FirestoreConstants.pathAnalysisCollection)
        .doc(chatId)
        .collection(FirestoreConstants.sentiment)
        .doc(time);
    Analysis analysis = Analysis(
        idFrom: currentUserId,
        date: time,
        messagesNumber: 0,
        sentimentNegative: 0,
        sentimentNeutral: 0,
        sentimentPositive: 0,
        sentimentNone: 0,
        sentiments: {});
    try {
      documentReference.get().then((DocumentSnapshot doc) {
        log.info("Checking if analysis already exist doc($doc)");
        if (doc.exists) {
          analysis.messagesNumber = doc[FirestoreConstants.messagesNumber];
          analysis.sentimentNegative =
              doc[FirestoreConstants.sentimentNegative];
          analysis.sentimentPositive =
              doc[FirestoreConstants.sentimentPositive];
          analysis.sentimentNeutral = doc[FirestoreConstants.sentimentNeutral];
          analysis.sentimentNone = doc[FirestoreConstants.sentimentNone];
          analysis.sentiments = doc[FirestoreConstants.sentiments];
        }
        log.info("Before update Analysis(${analysis.toJson()})");
        analysis.messagesNumber += 1;
        if (sentiment.contains(FirestoreConstants.sentimentNegative)) {
          analysis.sentimentNegative += 1;
        } else if (sentiment.contains(FirestoreConstants.sentimentPositive)) {
          analysis.sentimentPositive += 1;
        } else if (sentiment.contains(FirestoreConstants.sentimentNeutral)) {
          analysis.sentimentNeutral += 1;
        } else {
          analysis.sentimentNone += 1;
        }
        for (var key1 in sentiments) {
          analysis.sentiments.forEach((key2, value2) {
            if (key1 == key2) {
              analysis.sentiments[key1] = analysis.sentiments[key1]! + 1;
            } else {
              analysis.sentiments.addAll({key1: 1});
            }
          });
        }
        log.info("After update Analysis(${analysis.toJson()})");
        FirebaseFirestore.instance.runTransaction((transaction) async {
          transaction.set(
            documentReference,
            analysis.toJson(),
          );
        });
      });
    } catch (e) {
      errorCallback(e.toString());
    }
  }

  void updateAnalysisRandom(String currentUserId, String chatId,
      String sentiment, Function errorCallback) async {
    DateTime now = DateTime.now().subtract(const Duration(days: 30));
    for (var i = 0; i < 30; i++) {
      String time = DateFormat("MM_dd_yyyy").format(now);
      now = now.add(const Duration(days: 1));
      DocumentReference documentReference = firebaseFirestore
          .collection(FirestoreConstants.pathAnalysisCollection)
          .doc(chatId)
          .collection(FirestoreConstants.sentiment)
          .doc(time);
      int tr = Random().nextInt(100) + 30;
      int ur = Random().nextInt(30);
      int nor = Random().nextInt(10);
      int nr = Random().nextInt((tr - ur) - nor);
      int pr = ((tr - ur) - nor) - nr;
      Analysis analysis = Analysis(
          idFrom: currentUserId,
          date: time,
          messagesNumber: tr,
          sentimentNegative: nr,
          sentimentNeutral: ur,
          sentimentPositive: pr,
          sentimentNone: nor,
          sentiments: {});
      try {
        FirebaseFirestore.instance.runTransaction((transaction) async {
          transaction.set(
            documentReference,
            analysis.toJson(),
          );
        });
      } catch (e) {
        errorCallback(e.toString());
      }
    }
  }

  Future<int> isThereMessages(
      String currentUserId, String chatId, Function callback) async {
    log.info("Checking previous messages for chatId($chatId)");

    return await firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(chatId)
        .collection(FirestoreConstants.conv)
        .limit(10)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .get()
        .then((value) {
      log.info(
          "Previous messages with size(${value.size}) and limit(10): ${value.docs}");

      if (value.size > 2) {
        callback(value.docs.first.data());
      }
      return value.size;
    });
  }

  void deleteAllDocsInSubCollection(
      String collection, String doc, String subCol) {
    log.info("Deleting all docs for subcollection($collection/$doc/$subCol)");

    firebaseFirestore
        .collection(collection)
        .doc(doc)
        .collection(subCol)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
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
}
