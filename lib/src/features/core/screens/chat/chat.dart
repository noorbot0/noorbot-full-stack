import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:intl/intl.dart';
import 'package:noorbot_app/src/constants/firestore_constants.dart';
import 'package:noorbot_app/src/features/core/screens/chat/chat_provider.dart';
import 'package:noorbot_app/src/features/core/screens/chat/widgets/chat_waiting.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

// This widget is the home page of your application. It is stateful, meaning
// that it has a State object (defined below) that contains fields that affect
// how it looks.

// This class is the configuration for the state. It holds the values (in this
// case the title) provided by the parent (in this case the App widget) and
// used by the build method of the State. Fields in a Widget subclass are
// always marked "final".

  @override
// ignore: library_private_types_in_public_api
  Chat createState() => Chat();
}

class Chat extends State<MyHomePage> {
  // void response(query) async {
  //   AuthGoogle authGoogle = await AuthGoogle(
  //       fileJson: "assets/service.json")
  //       .build();
  //   Dialogflow dialogflow =
  //   Dialogflow(authGoogle: authGoogle, language: Language.english);
  //   AIResponse aiResponse = await dialogflow.detectIntent(query);
  //   setState(() {
  //     messsages.insert(0, {
  //       "data": 0,
  //       "message": aiResponse.getListMessage()[0]["text"]["text"][0].toString()
  //     });
  //   });

  //   print(aiResponse.getListMessage()[0]["text"]["text"][0].toString());
  //  }

  final messageInsert = TextEditingController();
  List<Map<String, String>> messages =
      List<Map<String, String>>.empty(growable: true);
  bool sendButtonEnabled = false;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String chatRoomId;
  late final ChatProvider chatProvider = context.read<ChatProvider>();
  final int _limit = 100;
  List<QueryDocumentSnapshot> listMessage = [];
  final ScrollController listScrollController = ScrollController();
  bool isSomeoneTyping = false;

  @override
  void initState() {
    super.initState();

    readLocal();
  }

  void readLocal() {
    chatRoomId = _auth.currentUser!.uid;
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
      setState(() {
        messages.add({"role": "user", "content": messageInsert.text.trim()});
        sendButtonEnabled = false;
        isSomeoneTyping = true;
      });
      void okCallback(String response) {
        setState(() {
          messages.add({"role": "assistant", "content": response.trim()});
          isSomeoneTyping = false;
        });
      }

      chatProvider.chatComplete(messages, _auth.currentUser!.uid, chatRoomId,
          messageInsert.text.trim(), okCallback);

      messageInsert.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Chat bot", style: TextStyle(color: Colors.black))),
      body: Column(
        children: <Widget>[
          // timeSection(),
          messagesSection(context),
          // typingRow(",", 0),
          TypingIndicator(
            showIndicator: isSomeoneTyping,
          ),
          const Divider(height: 1.0, color: Colors.grey),
          inputSection(),
        ],
      ),
    );
  }

  Widget timeSection() {
    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 10),
      child: Text(
        "Today, ${DateFormat("Hm").format(DateTime.now())}",
        style: const TextStyle(fontSize: 20),
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
                    // First Time messageing
                    chatProvider.storeMessage(
                        _auth.currentUser!.uid,
                        chatRoomId,
                        "Act as a Therapist. Your name is Noor. You are a helpful therapy assistant. Intreduce name and you can help people feel better and make them happy, then ask user the name. After that start asking about mental health things and how does user feel?",
                        "system");
                    chatProvider.storeMessage(
                        _auth.currentUser!.uid,
                        chatRoomId,
                        "Hello! My name is Noor and I'm here to help you feel better and happier. What's your name?",
                        "assistant");
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
                    // return const Center(
                    //   child: CircularProgressIndicator(
                    //     color: Colors.purple,
                    //   ),
                    // );
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

  Widget typingRow(String message, int sender) {
    return Row(
      mainAxisAlignment:
          sender == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        sender == 0
            ? const SizedBox(
                // height: 60,
                // width: 60,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage("assets/noor.png"),
                ),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TypingIndicator(
            showIndicator: isSomeoneTyping,
          ),
        ),
      ],
    );
  }

  //for better one i have use the bubble package check out the pubspec.yaml

  Widget messageWidget(String message, String role) {
    return Row(
      mainAxisAlignment: role == FirestoreConstants.userRole
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        role == FirestoreConstants.aiRole
            ? const SizedBox(
                // height: 60,
                // width: 60,
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
                      constraints: const BoxConstraints(maxWidth: 200),
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
        // sender == 1
        //     ? const SizedBox(
        //         height: 60,
        //         width: 60,
        //         child: CircleAvatar(
        //           backgroundImage: AssetImage("assets/dash-person.png"),
        //         ),
        //       )
        //     : Container(),
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
}
