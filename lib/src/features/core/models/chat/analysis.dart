import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noorbot_app/src/constants/firestore_constants.dart';

class Analysis {
  final String idFrom;
  final String date;
  int messagesNumber;
  int sentimentNegative;
  int sentimentPositive;
  int sentimentNeutral;
  int sentimentNone;

  Analysis({
    required this.idFrom,
    required this.date,
    required this.messagesNumber,
    required this.sentimentNegative,
    required this.sentimentPositive,
    required this.sentimentNeutral,
    required this.sentimentNone,
  });

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.idFrom: idFrom,
      FirestoreConstants.date: date,
      FirestoreConstants.messagesNumber: messagesNumber,
      FirestoreConstants.sentimentPositive: sentimentPositive,
      FirestoreConstants.sentimentNegative: sentimentNegative,
      FirestoreConstants.sentimentNeutral: sentimentNeutral,
      FirestoreConstants.sentimentNone: sentimentNone,
    };
  }

  factory Analysis.fromDocument(DocumentSnapshot doc) {
    String idFrom = doc.get(FirestoreConstants.idFrom);
    String date = doc.get(FirestoreConstants.date);
    int messagesNumber = doc.get(FirestoreConstants.messagesNumber);
    int sentimentPositive = doc.get(FirestoreConstants.sentimentPositive);
    int sentimentNegative = doc.get(FirestoreConstants.sentiment);
    int sentimentNeutral = doc.get(FirestoreConstants.sentiment);
    int sentimentNone = doc.get(FirestoreConstants.sentimentNone);
    return Analysis(
      idFrom: idFrom,
      date: date,
      messagesNumber: messagesNumber,
      sentimentPositive: sentimentPositive,
      sentimentNegative: sentimentNegative,
      sentimentNeutral: sentimentNeutral,
      sentimentNone: sentimentNone,
    );
  }
}