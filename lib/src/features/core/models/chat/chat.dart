import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noorbot_app/src/constants/firestore_constants.dart';

class MessageChat {
  final String idFrom;
  final String timestamp;
  final String content;
  final String role;

  const MessageChat({
    required this.idFrom,
    required this.timestamp,
    required this.content,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.idFrom: idFrom,
      FirestoreConstants.timestamp: timestamp,
      FirestoreConstants.content: content,
      FirestoreConstants.role: role,
    };
  }

  factory MessageChat.fromDocument(DocumentSnapshot doc) {
    String idFrom = doc.get(FirestoreConstants.idFrom);
    String timestamp = doc.get(FirestoreConstants.timestamp);
    String content = doc.get(FirestoreConstants.content);
    String role = doc.get(FirestoreConstants.role);
    return MessageChat(
      idFrom: idFrom,
      timestamp: timestamp,
      content: content,
      role: role,
    );
  }
}
