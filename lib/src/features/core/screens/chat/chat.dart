import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noorbot_app/src/constants/apis.dart';
// import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:noorbot_app/src/constants/firestore_constants.dart';
import 'package:noorbot_app/src/constants/text_strings.dart';
import 'package:noorbot_app/src/features/core/providers/chat_provider.dart';
import 'package:noorbot_app/src/features/core/providers/gpt_provider.dart';
import 'package:noorbot_app/src/features/core/providers/logger_provider.dart';
import 'package:noorbot_app/src/features/core/screens/chat/widgets/chat_waiting.dart';
import 'package:noorbot_app/src/features/core/screens/dashboard/widgets/appbar.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../../../../constants/image_strings.dart';

class MyChat extends StatefulWidget {
  const MyChat({Key? key}) : super(key: key);
  @override
  Chat createState() => Chat();
}

class Chat extends State<MyChat> {
  final int _limit = 100;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String chatRoomId;
  final messageInsert = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  List<Map<String, String>> messages =
      List<Map<String, String>>.empty(growable: true);
  late final ChatProvider chatProvider = context.read<ChatProvider>();
  late final GPTProvider gptProvider = context.read<GPTProvider>();
  late final LoggerProvider log = context.read<LoggerProvider>();
  List<QueryDocumentSnapshot> listMessage = [];
  late List<String>? suggestions;
  bool sendButtonEnabled = false;
  bool isSomeoneTyping = false;
  bool showSuggestions = false;
  bool isFirstMessage = false;
  bool isEverythingReady = false;

  @override
  void initState() {
    super.initState();
    chatRoomId = _auth.currentUser!.uid;
    log.info("{$chatRoomId} opened the chat");
    checkPreviousMessages();
  }

  void checkPreviousMessages() async {
    log.info("Checking last messages...");
    int prevNumber = await chatProvider
        .isThereMessages(_auth.currentUser!.uid, chatRoomId,
            (Map<String, dynamic> msg, int length) {
      log.info("Last message sent in the chat ($msg)");
      print(length);
      if (length == 2) {
        if (mounted) {
          setState(() {
            isEverythingReady = true;
          });
        } else {
          isEverythingReady = true;
        }
      } else {
        if (msg["role"] == FirestoreConstants.aiRole) {
          giveSuggestions(msg[FirestoreConstants.content]);
        } else {
          messageInsert.text = msg["content"];
          onSendMessageGPT(false, true);
          if (mounted) {
            setState(() {
              isEverythingReady = true;
            });
          } else {
            isEverythingReady = true;
          }
        }
      }
    });
    log.info("Got num($prevNumber) of last messages.");
    if (prevNumber < 2) {
      chatProvider.deleteAllDocsInSubCollection(
          FirestoreConstants.pathMessageCollection,
          chatRoomId,
          FirestoreConstants.conv);
      // setState(() {
      if (mounted) {
        setState(() {
          isFirstMessage = true;
          isEverythingReady = true;
        });
      } else {
        isEverythingReady = true;
        isFirstMessage = true;
      }
      // });
    }
  }

  void onSendMessage() async {
    if (messageInsert.text.trim().isNotEmpty) {
      setState(() {
        messages
            .add({"role": "assistant", "content": messageInsert.text.trim()});
        sendButtonEnabled = false;
        isSomeoneTyping = true;
      });
      void okCallback(Map response) {
        setState(() {
          messages
              .add({"role": "user", "content": response["response"].trim()});
          isSomeoneTyping = false;
        });
      }

      chatProvider.chatter(_auth.currentUser!.uid, chatRoomId,
          messageInsert.text.trim(), okCallback);

      messageInsert.clear();
    }
  }

  void onSendMessageGPT(bool storeContent, bool storeResponse) async {
    log.info(
        "Sending message to gpt storeContent($storeContent), storeResponse($storeResponse)");
    log.info("Messages length (${messages.length})");
    if (messageInsert.text.trim().isNotEmpty) {
      if (isFirstMessage) {
        isFirstMessage = false;
        log.info("Extracting user name...");
        gptProvider.extractSpeakerName(
            messageInsert.text.trim(), _auth.currentUser!.uid, chatRoomId,
            (String name) {
          log.verbose(
              "It's the first message from the user, so I extracted the name ($name)");
        });
      }
      setState(() {
        messages.add({"role": "user", "content": messageInsert.text.trim()});
        sendButtonEnabled = false;
        isSomeoneTyping = true;
        showSuggestions = false;
      });
      void okCallback(String response, List<String>? rs) {
        log.info("GPT responded with ($response)");
        log.info("GPT suggested messages ($rs)");
        if (rs != null) {
          setState(() {
            suggestions = rs;
            showSuggestions = true;
          });
        } else {
          setState(() {
            showSuggestions = false;
          });
        }
        setState(() {
          messages.add({"role": "assistant", "content": response.trim()});
          isSomeoneTyping = false;
        });
      }

      void errCallback(String response) {
        log.error("Got an error when responding by gpt ($response)");
        setState(() {
          showSuggestions = false;
          isSomeoneTyping = false;
        });
      }

      gptProvider.chatComplete(
          messages,
          _auth.currentUser!.uid,
          chatRoomId,
          messageInsert.text.trim(),
          okCallback,
          errCallback,
          storeContent,
          storeResponse);
      log.info("Clearing messageInsert");
      messageInsert.clear();
    }
  }

  void giveSuggestions(String response) {
    log.info("Giving suggestions for $response...");
    void callback(List<String>? rs) {
      log.info("Got suggestions: $rs");
      if (rs != null) {
        if (mounted) {
          setState(() {
            suggestions = rs;
            showSuggestions = true;
            isEverythingReady = true;
          });
        } else {
          suggestions = rs;
          showSuggestions = true;
          isEverythingReady = true;
        }
      } else {
        setState(() {
          showSuggestions = false;
          isEverythingReady = true;
        });
      }
      log.info(
          "After suggestions: showSuggestions($showSuggestions), isEverythingReady($isEverythingReady)");
    }

    gptProvider.suggestAnswers(
        response, _auth.currentUser!.uid, chatRoomId, callback);
  }

  void clickSuggestion(String value) {
    log.info("Clicked suggestion ($value)");
    messageInsert.text = value;
    onSendMessageGPT(true, true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        appBar: DashboardAppBar(
          isDark: isDark,
          topTitle: tChatPageName,
        ),
        // AppBar(title: const Text("NoorBot", style: TextStyle(color: Colors.black))),
        body: Column(
          children: <Widget>[
            messagesSection(context),
            TypingIndicator(
              showIndicator: !showSuggestions && isSomeoneTyping,
            ),
            const Divider(height: 1.0, color: Colors.grey),
            showSuggestions && !isSomeoneTyping
                ? Wrap(
                    spacing: 10,
                    alignment: WrapAlignment.center,
                    children: suggestions!
                        .map((value) => suggestIcon(value))
                        .toList())
                : const Row(),
            inputSection(),
          ],
        ),
      ),
    );
  }

  Widget messagesSection(BuildContext context) {
    return Flexible(
      child: chatRoomId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: chatProvider.getChatStream(chatRoomId, _limit),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                log.info(
                    "snapshot.hasData(${snapshot.hasData}), isEverythingReady($isEverythingReady)");
                if (snapshot.hasData && isEverythingReady) {
                  listMessage = snapshot.data!.docs;
                  if (listMessage.isEmpty && messages.isEmpty) {
                    isFirstMessage = true;
                    log.info("Storing first 2 defualt messages...");
                    chatProvider.storeMessage(_auth.currentUser!.uid,
                        chatRoomId, GPTAPIs.systemFirstMessagePrompt, "system");
                    chatProvider.storeMessage(_auth.currentUser!.uid,
                        chatRoomId, GPTAPIs.firstMessagePrompt, "assistant");
                  }
                  if (listMessage.isNotEmpty) {
                    messages.clear();
                    log.info(
                        "messages cleared localy and started building messages list...");
                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (context, index) {
                        messages.add({
                          "role": listMessage[index]["role"],
                          "content": listMessage[index]["content"].toString()
                        });
                        if (listMessage[index]["role"] != "system") {
                          return messageWidget(
                              listMessage[index]["content"].toString(),
                              listMessage[index]["role"]);
                        }
                        return null;
                      },
                      itemCount: snapshot.data?.docs.length,
                      reverse: true,
                      controller: listScrollController,
                    );
                  } else {
                    log.info("No messages here yet");
                    return const Center(child: Text("No message here yet..."));
                  }
                } else {
                  log.info("Loading messages from Firebase");
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.purple,
                    ),
                  );
                }
              },
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            ),
    );
  }

  Widget messageWidget(String message, String role) {
    return Row(
      mainAxisAlignment: role == FirestoreConstants.userRole
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        role == FirestoreConstants.aiRole
            ? const SizedBox(
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(tChatImage7),
                ),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Bubble(
              radius: const Radius.circular(15.0),
              color: role == FirestoreConstants.aiRole
                  ? const Color.fromRGBO(23, 157, 139, 1)
                  : Colors.orangeAccent,
              elevation: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                        child: Container(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: Text(
                        message,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ))
                  ],
                ),
              )),
        ),
      ],
    );
  }

  Widget inputSection() {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      title: Container(
        // height: 35,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: Colors.white, //Color.fromRGBO(220, 220, 220, 1),
          border: Border.all(color: const Color.fromARGB(255, 191, 191, 191)),
        ),
        padding: const EdgeInsets.only(left: 10),
        child: TextFormField(
          minLines: 1,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          controller: messageInsert,
          decoration: const InputDecoration(
            isDense: true,
            hintText: "Enter a Message...",
            hintStyle: TextStyle(color: Colors.black26),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
          style: const TextStyle(fontSize: 16, color: Colors.black),
          onChanged: (value) {
            setState(() {
              sendButtonEnabled = value.isNotEmpty;
            });
          },
        ),
      ),
      trailing: Ink(
        width: 35,
        decoration: ShapeDecoration(
          color: sendButtonEnabled
              ? const Color.fromARGB(255, 0, 117, 220)
              : const Color.fromARGB(255, 54, 76, 97),
          shape: const CircleBorder(),
        ),
        child: IconButton(
          icon: const Icon(
            Icons.send,
            size: 20.0,
            color: Colors.white,
          ),
          onPressed:
              sendButtonEnabled ? () => onSendMessageGPT(true, true) : null,
        ),
      ),
    );
  }

  Widget suggestIcon(String value) {
    return OutlinedButton(
      onPressed: () => clickSuggestion(value),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(10),
        foregroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(value),
    );
  }
}
