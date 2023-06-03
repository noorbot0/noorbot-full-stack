// import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
// import 'package:noorbot_app/src/constants/apis.dart';
import 'package:noorbot_app/src/constants/firestore_constants.dart';
import 'package:noorbot_app/src/features/core/providers/logger_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SentimentProvider {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  // final openAI = OpenAI.instance.build(
  //     token: GPTAPIs.keyToken,
  //     baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 20)),
  //     isLog: true);
  late final LoggerProvider log;

  SentimentProvider(
      {required this.firebaseFirestore,
      required this.prefs,
      required this.firebaseStorage}) {
    log = LoggerProvider(prefs: prefs);
  }

  String? getPref(String key) {
    return prefs.getString(key);
  }

  Future<List<Map<String, dynamic>>> getSentiments(
      String currentUserId, String chatId, Function errorCallback) async {
    // DateTime now = DateTime.now().toUtc();
    // String time = DateFormat("MM_dd_yyyy").format(now);
    DateTime now = DateFormat("MM_dd_yyyy").parse(
        "${DateTime.now().month}_${DateTime.now().day}_${DateTime.now().year}");
    log.info(
        "Getting sentiments for chatId($chatId) with limit (31) at date($now)");
    List<Map<String, dynamic>> allDocs = [];
    return await firebaseFirestore
        .collection(FirestoreConstants.pathAnalysisCollection)
        .doc(chatId)
        .collection(FirestoreConstants.sentiment)
        .orderBy(FirestoreConstants.date, descending: true)
        .limit(31)
        .get()
        .then(
      (querySnapshot) {
        log.info("Got sentiments number(${querySnapshot.docs.length})");
        for (var docSnapshot in querySnapshot.docs) {
          if (docSnapshot.data()["date"] != now) {
            allDocs.insert(0, docSnapshot.data());
          }
        }
        return allDocs;
      },
      onError: (e) => errorCallback(e.toString()),
    );
  }

  double calculateNetSentimentScore(Map<String, dynamic> day) {
    return (day[FirestoreConstants.sentimentPositive] -
            day[FirestoreConstants.sentimentNegative] +
            day[FirestoreConstants.sentimentNeutral] +
            day[FirestoreConstants.sentimentNone]) /
        day[FirestoreConstants.messagesNumber];
  }
}
