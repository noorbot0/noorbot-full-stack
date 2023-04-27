import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noorbot_app/src/constants/image_strings.dart';
import 'package:noorbot_app/src/constants/text_strings.dart';
import 'package:noorbot_app/src/features/bdi_test/screens/bdi_screen.dart';
import 'package:noorbot_app/src/utils/animations/fade_in_animation/animation_design.dart';
import 'package:noorbot_app/src/utils/animations/fade_in_animation/fade_in_animation_controller.dart';
import 'package:noorbot_app/src/utils/animations/fade_in_animation/fade_in_animation_model.dart';
import '../../../constants/sizes.dart';
import 'package:noorbot_app/src/features/core/screens/dashboard/widgets/appbar.dart';

class BdiTest extends StatelessWidget {
  const BdiTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FadeInAnimationController());
    controller.animationIn();

    var mediaQuery = MediaQuery.of(context);
    var width = mediaQuery.size.width;
    var height = mediaQuery.size.height;
    var brightness = mediaQuery.platformBrightness;

    final isDark = MediaQuery.of(context).platformBrightness ==
        Brightness.dark; //Dark mode
    return SafeArea(
        child: Scaffold(
            appBar: DashboardAppBar(
              isDark: isDark,
            ),
            body: Stack(children: [
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
                                  width: width * 0.4,
                                  height: height * 0.3)),
                          Column(
                            children: [
                              Text(tBdiTitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium),
                              Text(tBdiSubTitle,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Get.to(() => BdiScreen()),
                                  child: Text(tStart.toUpperCase()),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )))
            ])));
  }
}
