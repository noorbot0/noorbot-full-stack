import 'package:get/get.dart';
import 'package:noorbot_app/src/features/authentication/models/user_model.dart';
import 'package:noorbot_app/src/repository/authentication_repository/authentication_repository.dart';
import 'package:noorbot_app/src/repository/user_repository/user_repository.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  /// Repositories
  final _authRepo = AuthenticationRepository.instance;
  final _userRepo = UserRepository.instance;

  /// Get User Email and pass to UserRepository to fetch user record.
  getUserData() {
    try {
      final currentUserEmail = _authRepo.getUserEmail;
      if (currentUserEmail.isEmpty) {
        Get.snackbar("Error", "No user found!",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3));
        return;
      } else {
        return _userRepo.getUserDetails(currentUserEmail);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3));
    }
  }

  /// Fetch List of user records.
  Future<List<UserModel>> getAllUsers() async => await _userRepo.allUsers();

  /// Update User Data
  updateRecord(UserModel user) async {
    await _userRepo.updateUserRecord(user);
    //Show some message or redirect to other screen here...
    Get.snackbar("Updated", "User has been updated.");
  }

  Future<void> deleteUser() async {
    String uID = _authRepo.getUserID;
    if (uID.isEmpty) {
      Get.snackbar("Error", "User cannot be deleted.");
    } else {
      await _userRepo.deleteUser(uID);
      Get.snackbar("Success", "Account has been deleted.");
      // You can call your redirection to other screen here...
      // OR call the LOGOUT() function.
      _authRepo.logout();
    }
  }
}
