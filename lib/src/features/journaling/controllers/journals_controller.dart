import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:noorbot_app/src/features/authentication/models/user_model.dart';
import 'package:noorbot_app/src/features/journaling/models/journal_model.dart';
import 'package:noorbot_app/src/repository/authentication_repository/authentication_repository.dart';
import 'package:noorbot_app/src/repository/user_repository/user_repository.dart';
import 'package:noorbot_app/src/repository/journals_repository/journals_repository.dart';

class JournalsController extends GetxController {

  static JournalsController get instance => Get.find();

  /// Repositories
  final _authRepo = AuthenticationRepository.instance;
  final _userRepo = UserRepository.instance;
  final _journalRepo = JournalsRepository.instance;

  /// Get User Journals' Data
  createJournal(JournalModel journal) {
    try {
      final currentUserId = _authRepo.getUserEmail;
      if (currentUserId.isEmpty) {
        Get.snackbar("Error", "No user found!",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3));
        return;
      } else {
        _journalRepo.createJournal(journal);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3));
    }
  }

  /// Get User Journals' Data
  getUserJournalsData() {
    try {
      final currentUserId = _authRepo.getUserEmail;
      if (currentUserId.isEmpty) {
        Get.snackbar("Error", "No user found!",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3));
        return;
      } else {
        return _journalRepo.getJournalsForUser(currentUserId);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3));
    }
  }

  /// Get User Journals' Data
  getUserSpecificJournalData(DateTime createdAt) async {
    try {
      final currentUserId = _authRepo.getUserEmail;
      if (currentUserId.isEmpty) {
        Get.snackbar("Error", "No user found!",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3));
        return;
      } else {
        return await _journalRepo.getJournalForUser(currentUserId, createdAt);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3));
    }
  }


  /// Update User Journal Data
  updateRecord(String text, String title) async {
    try {
      final currentUserId = _authRepo.getUserEmail;
      if (currentUserId.isEmpty) {
        Get.snackbar("Error", "No user found!",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3));
        return;
      } else {
        await _journalRepo.updateUserJournalRecord(currentUserId, text, title);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3));
    }
    //Show some message or redirect to other screen here...
  }

  todayJournalExists() async {
    try {
      final currentUserId = _authRepo.getUserEmail;
      if (currentUserId.isEmpty) {
        Get.snackbar("Error", "No user found!",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3));
        return false;
      } else {
        return await _journalRepo.recordExist(currentUserId, DateTime.now());
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3));
    }
    //Show some message or redirect to other screen here...
  }


  deleteTodaysJournal() async {
    try {
      final currentUserId = _authRepo.getUserEmail;
      if (currentUserId.isEmpty) {
        Get.snackbar("Error", "No user found!",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3));
        return false;
      } else {
        await _journalRepo.deleteJournal(currentUserId);
      }
    } catch (e) {
    Get.snackbar("Error", e.toString(),
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 3));
    }
    //Show some message or redirect to other screen here...

  }

}
