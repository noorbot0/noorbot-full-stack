import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:intl/intl.dart';
import 'package:noorbot_app/src/features/core/screens/chat/chat_provider.dart';
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
  _Chat createState() => _Chat();
}

class _Chat extends State<MyHomePage> {
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
  List<Map> messsages = List<Map>.empty(growable: true);
  bool sendButtonEnabled = false;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String chatRoomId;
  late final ChatProvider chatProvider = context.read<ChatProvider>();
  final int _limit = 20;
  List<QueryDocumentSnapshot> listMessage = [];
  final ScrollController listScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    readLocal();
  }

  void readLocal() {
    String currentUserId = _auth.currentUser!.uid;
    chatRoomId = 'noorbot-$currentUserId';
  }

  void onSendMessage() async {
    if (messageInsert.text.trim().isNotEmpty) {
      setState(() {
        messsages.insert(0, {"data": 1, "message": messageInsert.text.trim()});
      });
      setState(() {
        sendButtonEnabled = false;
      });
      chatProvider.sendMessage(
          _auth.currentUser!.uid, chatRoomId, messageInsert.text.trim());
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
          timeSection(),
          messagesSection(context),
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
                  if (listMessage.isNotEmpty) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (context, index) => messageWidget(
                          listMessage[index]["content"].toString(),
                          listMessage[index]["sender"]),
                      // buildItem(index, snapshot.data?.docs[index]),
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

  //for better one i have use the bubble package check out the pubspec.yaml

  Widget messageWidget(String message, int sender) {
    return Container(
      // padding: const EdgeInsets.only(left: 5, right: 5),
      child: Row(
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
            padding: const EdgeInsets.all(5.0),
            child: Bubble(
                radius: const Radius.circular(15.0),
                color: sender == 0
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
      ),
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
          onPressed: sendButtonEnabled ? onSendMessage : null,
        ),
      ),
    );
  }
}
