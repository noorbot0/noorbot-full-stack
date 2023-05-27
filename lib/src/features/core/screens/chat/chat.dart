import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noorbot_app/src/constants/apis.dart';
// import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:noorbot_app/src/constants/firestore_constants.dart';
import 'package:noorbot_app/src/features/core/providers/chat_provider.dart';
import 'package:noorbot_app/src/features/core/providers/gpt_provider.dart';
import 'package:noorbot_app/src/features/core/screens/chat/widgets/chat_waiting.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

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
    checkPreviousMessages();
  }

  void checkPreviousMessages() async {
    int prevNumber = await chatProvider.isThereMessages(
        _auth.currentUser!.uid, chatRoomId, (Map<String, dynamic> msg) {
      giveSuggestions(msg[FirestoreConstants.content]);
      setState(() {
        isEverythingReady = true;
      });
    });
    if (prevNumber < 3) {
      setState(() {
        isFirstMessage = true;
      });
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
        // print("-------------------callback");
        // print(response["response"]);
        setState(() {
          messages
              .add({"role": "user", "content": response["response"].trim()});
          isSomeoneTyping = false;
        });
      }

      // void errCallback(error) {
      //   print(error);
      // }

      // chatProvider.chatGCFunction(_auth.currentUser!.uid, chatRoomId,
      //     messageInsert.text.trim(), okCallback, errCallback);
      chatProvider.chatter(_auth.currentUser!.uid, chatRoomId,
          messageInsert.text.trim(), okCallback);

      messageInsert.clear();
    }
  }

  void onSendMessageGPT() async {
    print(messages.length);
    if (messageInsert.text.trim().isNotEmpty) {
      print(isFirstMessage);
      if (isFirstMessage) {
        isFirstMessage = false;
        gptProvider.extractSpeakerName(
            messageInsert.text.trim(), _auth.currentUser!.uid, chatRoomId,
            (String name) {
          print(name);
        });
      }
      setState(() {
        messages.add({"role": "user", "content": messageInsert.text.trim()});
        sendButtonEnabled = false;
        isSomeoneTyping = true;
        showSuggestions = false;
      });
      void okCallback(String response, List<String>? rs) {
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
        print("ERROR---------------------\n$response");
        setState(() {
          showSuggestions = false;
          isSomeoneTyping = false;
        });
      }

      gptProvider.chatComplete(messages, _auth.currentUser!.uid, chatRoomId,
          messageInsert.text.trim(), okCallback, errCallback);

      messageInsert.clear();
    }
  }

  void giveSuggestions(String response) {
    void callback(List<String>? rs) {
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
    }

    gptProvider.suggestAnswers(
        response, _auth.currentUser!.uid, chatRoomId, callback);
  }

  void clickSuggestion(String value) {
    messageInsert.text = value;
    onSendMessageGPT();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Chat bot", style: TextStyle(color: Colors.black))),
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
                  children:
                      suggestions!.map((value) => suggestIcon(value)).toList())
              : Row(),
          inputSection(),
        ],
      ),
    );
  }

  Widget messagesSection(BuildContext context) {
    return Flexible(
      child: chatRoomId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: chatProvider.getChatStream(chatRoomId, _limit),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessage = snapshot.data!.docs;
                  if (listMessage.isEmpty && messages.isEmpty) {
                    isFirstMessage = true;
                    // First Time messageing
                    chatProvider.storeMessage(_auth.currentUser!.uid,
                        chatRoomId, GPTAPIs.systemFirstMessagePrompt, "system");
                    chatProvider.storeMessage(_auth.currentUser!.uid,
                        chatRoomId, GPTAPIs.firstMessagePrompt, "assistant");
                    // setState(() {
                    // chatProvider.getFirst(
                    //     _auth.currentUser!.uid,
                    //     chatRoomId,
                    //     (firstMsg) => {
                    //           if (listMessage.isEmpty && messages.isEmpty)
                    //             messages.insert(0, {
                    //               "role": "user",
                    //               "content": firstMsg,
                    //             })
                    //         });
                    // });
                  }
                  if (listMessage.isNotEmpty) {
                    messages.clear();
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
                    return const Center(child: Text("No message here yet..."));
                  }
                } else {
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
                  backgroundImage: AssetImage("assets/noor.png"),
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
          onPressed: sendButtonEnabled ? onSendMessageGPT : null,
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
