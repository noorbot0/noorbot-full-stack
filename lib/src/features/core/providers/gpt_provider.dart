import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:noorbot_app/src/constants/apis.dart';
import 'package:noorbot_app/src/constants/firestore_constants.dart';
import 'package:noorbot_app/src/features/core/providers/chat_provider.dart';
import 'package:noorbot_app/src/features/core/providers/logger_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GPTProvider {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  final openAI = OpenAI.instance.build(
      token: GPTAPIs.keyToken,
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 20)),
      isLog: true);
  late ChatProvider cp;
  late final LoggerProvider log;

  GPTProvider(
      {required this.firebaseFirestore,
      required this.prefs,
      required this.firebaseStorage}) {
    cp = ChatProvider(
        firebaseFirestore: firebaseFirestore,
        prefs: prefs,
        firebaseStorage: firebaseStorage);
    log = LoggerProvider(prefs: prefs);
  }

  String? getPref(String key) {
    return prefs.getString(key);
  }

  void chatComplete(
      List<Map<String, String>> msgs,
      String currentUserId,
      String chatId,
      String content,
      Function callback,
      Function errCallback,
      bool storeContent,
      bool storeResponse) async {
    log.info(
        "Completing messages for chatId($chatId) of content($content) with storeContent($storeContent), storeResponse($storeResponse)");
    if (storeContent) {
      String time = cp.storeMessage(
          currentUserId, chatId, content, FirestoreConstants.userRole);
      void analyserCallBack(String resp) {
        cp.updateMessage(currentUserId, chatId, time, content, resp,
            FirestoreConstants.userRole);
      }

      sentimentAnalysis(
          content, currentUserId, chatId, analyserCallBack, errCallback);
    }
    final request = ChatCompleteText(
        messages: msgs, maxToken: 300, model: ChatModel.gptTurbo);
    ChatCTResponse? response;
    try {
      response = await openAI.onChatCompletion(request: request);
      log.info("Chat completion($response)");
    } catch (e) {
      errCallback(e.toString());
    }
    String? firstRes = "";
    for (var element in response!.choices) {
      firstRes = element.message?.content;
    }

    suggestAnswers(firstRes!, currentUserId, chatId, (List<String>? rs) {
      log.info("Suggested answers for ($firstRes) are ($rs)");
      if (storeResponse) {
        cp.storeMessage(
            currentUserId, chatId, firstRes!, FirestoreConstants.aiRole);
      }
      callback(firstRes, rs);
    });
  }

  void sentimentAnalysis(String message, String currentUserId, String chatId,
      Function callback, Function errorCallback) {
    log.info("Analysing message($message) of chatId($chatId)");
    doRequst(GPTAPIs.sentimentPrompt(message), currentUserId, chatId,
        (String rs) {
      log.info("Analysis($rs)");
      cp.updateAnalysis(currentUserId, chatId, rs, errorCallback);
      callback(rs);
    });
  }

  void extractSpeakerName(
      String message, String currentUserId, String chatId, Function callback) {
    log.info("Extract speaker name for message($message) of chatId($chatId)");

    doRequst(GPTAPIs.nameExtractPrompt(message), currentUserId, chatId,
        (String response) {
      log.info("Extracted speaker name($response)");

      if (response.isNotEmpty &&
          !response.contains("None") &&
          !response.contains("none")) {
        response.replaceAll(".", "");
        callback(response);
      }
    });
  }

  void suggestAnswers(
      String message, String currentUserId, String chatId, Function callback) {
    log.info("Suggest answers for message($message) of chatId($chatId)");

    doRequst(GPTAPIs.defaultAnswersPrompt(message), currentUserId, chatId,
        (String response) {
      log.info("Got suggestions($response), started parsing...");
      List<String>? suggestions;
      if (response.isNotEmpty &&
          (!response.contains("None") || !response.contains("none"))) {
        suggestions = response.split(",");

        for (int i = 0; i < suggestions.length; i++) {
          suggestions[i] = suggestions[i].trim();
          suggestions[i] = suggestions[i].replaceAll(".", "");
          if (suggestions[i].isEmpty) {
            suggestions.remove(suggestions[i]);
            continue;
          }
          int counter = 0;
          for (var el2 in suggestions) {
            if (suggestions[i] == el2) {
              counter++;
            }
          }
          if (counter > 1) {
            suggestions.removeAt(counter);
          }
        }
        callback(suggestions);
      } else {
        callback(null);
      }
    });
  }

  void doRequst(String prompt, String currentUserId, String chatId,
      Function callback) async {
    log.info("Sending a request prompt($prompt) of chatId($chatId)");

    final request = CompleteText(
        model: Model.textDavinci3,
        prompt: prompt,
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

    callback(res!.trim());
  }
}
