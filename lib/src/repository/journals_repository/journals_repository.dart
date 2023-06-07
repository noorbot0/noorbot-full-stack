import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:noorbot_app/src/features/journaling/models/journal_model.dart';

import '../authentication_repository/exceptions/t_exceptions.dart';

class JournalsRepository extends GetxController {
  static JournalsRepository get instance => Get.find();

  static const String journalsCollection = "journals";
  static const String usersCollection = "Users";

  final _db = FirebaseFirestore.instance;

  bool _isSameDate(DateTime d1, DateTime d2) {
    if (d1.day != d2.day || d1.month != d2.month || d1.year != d2.year) {
      return false;
    }
    return true;
  }

  /// Store user data
  Future<void> createJournal(JournalModel journal) async {
    try {
      await recordExist(journal.user, journal.createdAt.toDate())
          ? throw "Record Already Exists"
          : await _db.collection(journalsCollection).add(journal.toJson());
    } on FirebaseAuthException catch (e) {
      final result = TExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString().isEmpty
          ? 'Something went wrong. Please Try Again'
          : e.toString();
    }
  }

  /// Fetch User Specific details
  Future<List<JournalModel>> getJournalsForUser(String email) async {
    try {
      final userJournalsSnapshot = await _db
          .collection(journalsCollection)
          .where("user", isEqualTo: email)
          .orderBy("created_at", descending: true)
          .get();
      if (userJournalsSnapshot.docs.isEmpty) throw 'No journals for user';
      final userJournalsData = userJournalsSnapshot.docs
          .map((e) => JournalModel.fromSnapshot(e))
          .toList();
      return userJournalsData;
    } on FirebaseAuthException catch (e) {
      final result = TExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString().isEmpty
          ? 'Something went wrong. Please Try Again'
          : e.toString();
    }
  }

  /// Fetch User Specific details
  Future<JournalModel> getJournalForUser(
      String email, DateTime createdAt) async {
    try {
      final userJournalsSnapshot = await _db
          .collection(journalsCollection)
          .where("user", isEqualTo: email)
          .orderBy("created_at", descending: true)
          .get();
      if (userJournalsSnapshot.docs.isEmpty) throw 'No journals for user';
      var userJournalsData = userJournalsSnapshot.docs
          .map((e) => JournalModel.fromSnapshot(e))
          .toList();

      return userJournalsData
          .where(
              (element) => _isSameDate(element.createdAt.toDate(), createdAt))
          .toList()
          .single;
    } on FirebaseAuthException catch (e) {
      final result = TExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString().isEmpty
          ? 'Something went wrong. Please Try Again'
          : e.toString();
    }
  }

  /// Fetch All Users
  Future<List<JournalModel>> getAllJournals() async {
    try {
      final snapshot = await _db.collection("journals").get();
      final journals =
          snapshot.docs.map((e) => JournalModel.fromSnapshot(e)).toList();
      return journals;
    } on FirebaseAuthException catch (e) {
      final result = TExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (_) {
      throw 'Something went wrong. Please Try Again';
    }
  }

  /// Update user today's journal record
  Future<void> updateUserJournalRecord(
      String email, String text, String title) async {
    try {
      final userTodayJournalSnapshot = await _db
          .collection(journalsCollection)
          .where("user", isEqualTo: email)
          .orderBy("created_at", descending: true)
          .get();
      if (userTodayJournalSnapshot.docs.isEmpty) throw 'No journals for user';
      JournalModel userJournalsData = userTodayJournalSnapshot.docs
          .map((e) => JournalModel.fromSnapshot(e))
          .first;
      DateTime journalDate = userJournalsData.createdAt.toDate();
      DateTime todayDate = DateTime.now();
      if (!_isSameDate(todayDate, journalDate)) {
        // Journal doesn't exist, Create journal
        // TODO: Must validate that this user is authenticated and exists
        // Note: could do the above by getting the user email from Authentication Repo
        await _db.collection(usersCollection).add(JournalModel(
                user: email,
                text: "",
                title: "My Journal Today",
                createdAt: Timestamp.now())
            .toJson());
        return;
      }
      userJournalsData.text = text;
      userJournalsData.title = title;
      await _db
          .collection(journalsCollection)
          .doc(userJournalsData.id)
          .update(userJournalsData.toJson());
    } on FirebaseAuthException catch (e) {
      final result = TExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (_) {
      throw 'Something went wrong. Please Try Again';
    }
  }

  /// Delete Today's Journal
  Future<void> deleteJournal(String email) async {
    try {
      final userTodayJournalSnapshot = await _db
          .collection(journalsCollection)
          .where("user", isEqualTo: email)
          .orderBy("created_at", descending: true)
          .get();
      if (userTodayJournalSnapshot.docs.isEmpty) return;
      JournalModel userJournalsData = userTodayJournalSnapshot.docs
          .map((e) => JournalModel.fromSnapshot(e))
          .first;
      DateTime journalDate = userJournalsData.createdAt.toDate();
      DateTime todayDate = DateTime.now();
      if (!_isSameDate(todayDate, journalDate)) {
        return;
      }

      await _db
          .collection(journalsCollection)
          .doc(userJournalsData.id)
          .delete();
    } on FirebaseAuthException catch (e) {
      final result = TExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (_) {
      throw 'Something went wrong. Please Try Again';
    }
  }

  /// Check if user exists with same date
  Future<bool> recordExist(String email, DateTime date) async {
    try {
      final userTodayJournalSnapshot = await _db
          .collection(journalsCollection)
          .where("user", isEqualTo: email)
          .orderBy("created_at", descending: true)
          .get();
      if (userTodayJournalSnapshot.docs.isEmpty) return false;
      JournalModel userJournalsData = userTodayJournalSnapshot.docs
          .map((e) => JournalModel.fromSnapshot(e))
          .first;
      DateTime journalDate = userJournalsData.createdAt.toDate();
      if (!_isSameDate(date, journalDate)) {
        return false;
      }
      return true;
    } catch (e) {
      throw "Error fetching record.";
    }
  }
}
