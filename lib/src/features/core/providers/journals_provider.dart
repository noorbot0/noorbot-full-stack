// import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:noorbot_app/src/constants/apis.dart';
import 'package:noorbot_app/src/constants/firestore_constants.dart';
import 'package:noorbot_app/src/features/core/providers/logger_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JournalsProvider {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  // final openAI = OpenAI.instance.build(
  //     token: GPTAPIs.keyToken,
  //     baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 20)),
  //     isLog: true);
  late final LoggerProvider log;

  JournalsProvider(
      {required this.firebaseFirestore,
      required this.prefs,
      required this.firebaseStorage}) {
    log = LoggerProvider(prefs: prefs);
  }

  String? getPref(String key) {
    return prefs.getString(key);
  }

  Future<List<Map<String, dynamic>>> getJournals(
      String currentUserId, String chatId, Function errorCallback) async {
    log.info("Getting journals for chatId($chatId)");
    List<Map<String, dynamic>> allDocs = [];
    return await firebaseFirestore
        .collection(FirestoreConstants.pathJournalsCollection)
        .doc(chatId)
        .collection(FirestoreConstants.journal)
        .orderBy(FirestoreConstants.createdAt, descending: true)
        .get()
        .then(
      (querySnapshot) {
        log.info("Got journals number(${querySnapshot.docs.length})");
        for (var docSnapshot in querySnapshot.docs) {
          allDocs.insert(0, docSnapshot.data());
        }
        return allDocs;
      },
      onError: (e) => errorCallback(e.toString()),
    );
  }
}
