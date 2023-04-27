import 'package:get/get.dart';
import 'package:liquid_swipe/PageHelpers/LiquidController.dart';
import 'package:noorbot_app/src/features/bdi_test/screens/bdi_test.dart';
// import 'package:noorbot_app/src/features/core/screens/dashboard/dashboard.dart';
import '../../../constants/colors.dart';
import '../../../constants/image_strings.dart';
import '../../../constants/text_strings.dart';
import '../../core/screens/bottom_navbar/bottom_navbar.dart';
import '../models/model_on_boarding.dart';
import '../screens/on_boarding/on_boarding_page_widget.dart';

class OnBoardingController extends GetxController {
  //Variables
  final controller = LiquidController();
  RxInt currentPage = 0.obs;

  //Functions to trigger Skip, Next and onPageChange Events
  skip() => Get.offAll(() => const BdiTest());
  skip() => Get.offAll(() => const MyNavBar());
  animateToNextSlide() =>
      controller.animateToPage(page: controller.currentPage + 1);
  onPageChangedCallback(int activePageIndex) =>
      currentPage.value = activePageIndex;

  //Three Onboarding Pages
  final pages = [
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: tOnBoardingImage1,
        title: tOnBoardingTitle1,
        subTitle: tOnBoardingSubTitle1,
        counterText: tOnBoardingCounter1,
        bgColor: tOnBoardingPage1Color,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: tOnBoardingImage2,
        title: tOnBoardingTitle2,
        subTitle: tOnBoardingSubTitle2,
        counterText: tOnBoardingCounter2,
        bgColor: tOnBoardingPage2Color,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: tOnBoardingImage3,
        title: tOnBoardingTitle3,
        subTitle: tOnBoardingSubTitle3,
        counterText: tOnBoardingCounter3,
        bgColor: tOnBoardingPage3Color,
      ),
    ),
  ];
}
