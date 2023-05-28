// import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:noorbot_app/src/constants/apis.dart';
import 'package:noorbot_app/src/constants/firestore_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SentimentProvider {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  // final openAI = OpenAI.instance.build(
  //     token: GPTAPIs.keyToken,
  //     baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 20)),
  //     isLog: true);

  SentimentProvider(
      {required this.firebaseFirestore,
      required this.prefs,
      required this.firebaseStorage});

  String? getPref(String key) {
    return prefs.getString(key);
  }

  Future<List<Map<String, dynamic>>> getSentiments(
      String currentUserId, String chatId) async {
    // DateTime now = DateTime.now().toUtc();
    // String time = DateFormat("MM_dd_yyyy").format(now);
    List<Map<String, dynamic>> allDocs = [];
    return await firebaseFirestore
        .collection(FirestoreConstants.pathAnalysisCollection)
        .doc(chatId)
        .collection(FirestoreConstants.sentiment)
        .orderBy(FirestoreConstants.date, descending: false)
        .limit(30)
        .get()
        .then(
      (querySnapshot) {
        int counter = 1;
        for (var docSnapshot in querySnapshot.docs) {
          if (counter < querySnapshot.size) allDocs.add(docSnapshot.data());
          counter++;
        }
        return allDocs;
      },
      onError: (e) => print("Error completing: $e"),
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
