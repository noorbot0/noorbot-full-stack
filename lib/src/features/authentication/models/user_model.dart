import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String nickname;
  final String email;
  final String password;
  final String notificationTime;
  final int testScore;

  /// Constructor
  const UserModel(
      {this.id,
      required this.email,
      required this.password,
      this.nickname = "ally",
      this.notificationTime = 'evening',
      this.testScore = 0});

  /// convert model to Json structure so that you can it to store data in Firesbase
  toJson() {
    return {
      "Nickname": nickname,
      "Email": email,
      "Password": password,
      "Notification_Time": notificationTime,
      "Test_Score": testScore,
    };
  }

  /// Map Json oriented document snapshot from Firebase to UserModel
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      id: document.id,
      email: data["Email"],
      password: data["Password"],
      nickname: data["Nickname"],
      notificationTime: data["Notification_Time"],
      testScore: data["Test_Score"]
    );
  }
}
