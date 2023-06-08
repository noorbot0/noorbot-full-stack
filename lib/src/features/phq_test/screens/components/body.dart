import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noorbot_app/src/constants/colors.dart';
import 'package:noorbot_app/src/features/phq_test/controllers/question_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'question_card.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // int _processValue = 0;
  @override
  Widget build(BuildContext context) {
    // So that we have acccess our controller
    QuestionController questionController = Get.put(QuestionController());
    return Stack(
      children: [
        SafeArea(
          child: Column(
            children: [
              SmoothPageIndicator(
                controller: questionController.pageController,
                count: questionController.questions.length,
                effect: JumpingDotEffect(
                  activeDotColor: tmainGreenColor,
                  dotColor: Colors.deepPurple.shade100,
                  dotHeight: 10,
                  dotWidth: 10,
                  spacing: 6,
                  verticalOffset: 50,
                  jumpScale: 1,
                ),
              ),
              const SizedBox(height: kDefaultPadding),
              Expanded(
                child: PageView.builder(
                  // Block swipe to next qn
                  physics: const NeverScrollableScrollPhysics(),
                  controller: questionController.pageController,
                  // onPageChanged: (int x) {
                  // setState(() {
                  //   _processValue = questionController.updateTheQnNum(
                  //       questionController.questionNumber.value);
                  // });
                  // },
                  itemCount: questionController.questions.length,
                  itemBuilder: (context, index) => QuestionCard(
                      question: questionController.questions[index]),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
