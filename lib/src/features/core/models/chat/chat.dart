import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noorbot_app/src/constants/firestore_constants.dart';

class MessageChat {
  final String idFrom;
  final String timestamp;
  final String content;
  final int sender;

  const MessageChat({
    required this.idFrom,
    required this.timestamp,
    required this.content,
    required this.sender,
  });

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.idFrom: idFrom,
      FirestoreConstants.timestamp: timestamp,
      FirestoreConstants.content: content,
      FirestoreConstants.sender: sender,
    };
  }

  factory MessageChat.fromDocument(DocumentSnapshot doc) {
    String idFrom = doc.get(FirestoreConstants.idFrom);
    String timestamp = doc.get(FirestoreConstants.timestamp);
    String content = doc.get(FirestoreConstants.content);
    int sender = doc.get(FirestoreConstants.sender);
    return MessageChat(
      idFrom: idFrom,
      timestamp: timestamp,
      content: content,
      sender: sender,
    );
  }
}
