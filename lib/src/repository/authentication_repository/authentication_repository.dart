import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:noorbot_app/src/features/authentication/screens/on_boarding/on_boarding_screen.dart';
import 'package:noorbot_app/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:noorbot_app/src/features/core/screens/bottom_navbar/bottom_navbar.dart';

import 'exceptions/t_exceptions.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  /// Variables
  late final GoogleSignInAccount googleUser;
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> _firebaseUser;
  var verificationId = ''.obs;

  /// QUICK links to get frequently used values in other classes.
  User? get firebaseUser => _firebaseUser.value;

  String get getUserID => _firebaseUser.value?.uid ?? "";

  String get getUserEmail => _firebaseUser.value?.email ?? "";

  /// When App launch, this func called.
  /// It set the firebaseUser state & remove the Splash Screen
  @override
  void onReady() {
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.userChanges());
    FlutterNativeSplash.remove();
    ever(_firebaseUser, _setInitialScreen);
  }

  /// Setting initial screen onLOAD (optional)
  _setInitialScreen(User? user) async {
    user == null
        ? Get.offAll(() => const WelcomeScreen())
        // : await UserRepository.instance.recordExist(user.email ?? "")
        : Get.offAll(() => const MyNavBar());
    // : Get.offAll(() => const Dashboard());
  }

  /// [GoogleAuthentication]
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      googleUser = (await GoogleSignIn().signIn())!;

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      final ex = TExceptions.fromCode(e.code);
      throw ex.message;
    } catch (e) {
      throw e.toString().isEmpty
          ? 'Unknown Error Occurred. Try again!'
          : e.toString();
    }
  }

  /// [EmailAuthentication] - LOGIN
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final result =
          TExceptions.fromCode(e.code); // Throw custom [message] variable
      throw result.message;
    } catch (_) {
      const result = TExceptions();
      throw result.message;
    }
  }

  /// [EmailAuthentication] - REGISTER
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firebaseUser != null
          ? Get.offAll(() => const OnBoardingScreen())
          : Get.to(() => const WelcomeScreen());
    } on FirebaseAuthException catch (e) {
      final ex = TExceptions.fromCode(e.code);
      throw ex.message;
    } catch (_) {
      const ex = TExceptions();
      throw ex.message;
    }
  }

  /// LOGOUT USER - Valid for GOOGLE & other authentications.
  Future<void> logout() async {
    await GoogleSignIn().disconnect();
    await _auth.signOut();
  }
}
