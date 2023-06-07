import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noorbot_app/src/features/authentication/models/user_model.dart';
import 'package:noorbot_app/src/repository/user_repository/user_repository.dart';
import '../../../repository/authentication_repository/authentication_repository.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final userRepo = UserRepository.instance; //Call Get.put(UserRepo) if not define in AppBinding file (main.dart)

  // TextField Controllers to get data from TextFields
  final email = TextEditingController();
  final password = TextEditingController();
  final nickname = TextEditingController();

  /// Loader
  final isLoading = false.obs;

  /// Register New User using  [EmailAndPassword] authentication
  Future<void> createUser(UserModel user) async {
    try {
      isLoading.value = true;
      await emailAuthentication(user.email, user.password); //Perform authentication
      await userRepo.createUser(user); //Store Data in FireStore
      // AuthenticationRepository.instance.firebaseUser.refresh();
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Sorry", e.toString(), snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 5));
    }
  }

  /// [EmailAuthentication]
  Future<void> emailAuthentication(String email, String password) async {
    try {
      await AuthenticationRepository.instance.createUserWithEmailAndPassword(email, password);
    } catch (e) {
      throw e.toString();
    }
  }



  /// [GoogleSignInAuthentication]
  Future<void> googleSignIn() async {
    try {
      isLoading.value = true;
      await AuthenticationRepository.instance.signInWithGoogle();
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Sorry", e.toString(), snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 5));
    }
  }
}
