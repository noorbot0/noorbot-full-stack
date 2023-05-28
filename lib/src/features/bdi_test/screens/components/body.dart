import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noorbot_app/src/constants/colors.dart';
import 'package:noorbot_app/src/features/bdi_test/controllers/question_controller.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'question_card.dart';

class Body extends StatelessWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // So that we have acccess our controller
    QuestionController questionController = Get.put(QuestionController());
    return Stack(
      children: [
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width - 50,
                  animation: true,
                  lineHeight: 20.0,
                  animationDuration: 500,
                  percent: (questionController.questionNumber.value * 1.0) /
                      questionController.questions.length,
                  // ignore: deprecated_member_use
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: tPrimaryColor,
                ),
              ),
              const SizedBox(height: kDefaultPadding),
              Expanded(
                child: PageView.builder(
                  // Block swipe to next qn
                  physics: const NeverScrollableScrollPhysics(),
                  controller: questionController.pageController,
                  onPageChanged: questionController.updateTheQnNum,
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
