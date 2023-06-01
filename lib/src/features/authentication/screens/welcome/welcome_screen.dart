import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noorbot_app/src/constants/sizes.dart';
import 'package:noorbot_app/src/features/authentication/screens/signup/signup_screen.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/image_strings.dart';
import '../../../../constants/text_strings.dart';
import '../../../../utils/animations/fade_in_animation/animation_design.dart';
import '../../../../utils/animations/fade_in_animation/fade_in_animation_controller.dart';
import '../../../../utils/animations/fade_in_animation/fade_in_animation_model.dart';
import '../login/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FadeInAnimationController());
    controller.animationIn();

    var mediaQuery = MediaQuery.of(context);
    var width = mediaQuery.size.width;
    var height = mediaQuery.size.height;
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return SafeArea(
      child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: tbackgroundColor)),
          child: Scaffold(
            backgroundColor: isDarkMode ? tSecondaryColor : Colors.transparent,
            body: Stack(
              children: [
                TFadeInAnimation(
                  isTwoWayAnimation: false,
                  durationInMs: 1200,
                  animate: TAnimatePosition(
                    bottomAfter: 0,
                    bottomBefore: -100,
                    leftBefore: 0,
                    leftAfter: 0,
                    topAfter: 0,
                    topBefore: 0,
                    rightAfter: 0,
                    rightBefore: 0,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(tDefaultSize),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Hero(
                            tag: 'welcome-image-tag',
                            child: Image(
                                image: const AssetImage(tWelcomeScreenImage),
                                width: width * 0.7,
                                height: height * 0.6)),
                        Column(
                          children: [
                            Text(tWelcomeTitle,
                                style:
                                    Theme.of(context).textTheme.displayMedium),
                            Text(tWelcomeSubTitle,
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign.center),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () =>
                                    Get.to(() => const LoginScreen()),
                                child: Text(tLogin.toUpperCase()),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () =>
                                    Get.to(() => const SignUpScreen()),
                                child: Text(tSignup.toUpperCase()),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
