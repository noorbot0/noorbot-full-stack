import 'package:get/get.dart';
import 'package:noorbot_app/src/features/authentication/controllers/login_controller.dart';
import 'package:noorbot_app/src/features/authentication/controllers/on_boarding_controller.dart';
import 'package:noorbot_app/src/features/authentication/controllers/signup_controller.dart';
import 'package:noorbot_app/src/repository/user_repository/user_repository.dart';
import '../repository/authentication_repository/authentication_repository.dart';

class AppBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => AuthenticationRepository(), fenix: true);
    Get.lazyPut(() => UserRepository(), fenix: true);

    Get.lazyPut(() => OnBoardingController(), fenix: true);

    Get.lazyPut(() => LoginController(), fenix: true);
    Get.lazyPut(() => SignUpController(), fenix: true);
  }

}