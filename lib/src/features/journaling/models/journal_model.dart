import 'package:cloud_firestore/cloud_firestore.dart';

class JournalModel {
  final String? id;
  final String user;
  late  String text;
  late String title;
  final Timestamp createdAt;

  /// Constructor
  JournalModel(
      {this.id,
        required this.user,
        required this.text,
        required this.title,
        required this.createdAt});


  /// convert model to Json structure so that you can it to store data in Firesbase
  toJson() {
    return {
      "user": user,
      "text": text,
      "title": title,
      "created_at": createdAt,
    };
  }

  /// Map Json oriented document snapshot from Firebase to UserModel
  factory JournalModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return JournalModel(
        id: document.id,
        user: data["user"],
        text: data["text"],
        title: data["title"],
        createdAt: data["created_at"],
    );
  }
}
