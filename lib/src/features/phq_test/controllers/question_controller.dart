import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:noorbot_app/src/common_widgets/custome_dialog.dart';
import 'package:noorbot_app/src/features/core/controllers/profile_controller.dart';
import 'package:noorbot_app/src/features/core/screens/bottom_navbar/bottom_navbar.dart';
import 'package:noorbot_app/src/features/phq_test/models/Questions.dart';

// We use get package for our state management

class QuestionController extends GetxController {
  late PageController _pageController;
  PageController get pageController => _pageController;
  final controller = Get.put(ProfileController());
  final List<Question> _questions = sampleData
      .map(
        (question) => Question(
            id: question['id'],
            question: question['question'],
            options: question['options'],
            answer: question['answer_index']),
      )
      .toList();
  List<Question> get questions => _questions;

  bool _isAnswered = false;
  bool get isAnswered => _isAnswered;

  late int _correctAns;
  int get correctAns => _correctAns;

  late int _selectedAns;
  int get selectedAns => _selectedAns;

  // for more about obs please check documentation
  final RxInt _questionNumber = 1.obs;
  RxInt get questionNumber => _questionNumber;

  final RxInt _score = 0.obs;
  RxInt get score => _score;

  // called immediately after the widget is allocated memory
  @override
  void onInit() {
    // Our animation duration is 60 s
    // so our plan is to fill the progress bar within 60s
    _pageController = PageController();
    super.onInit();
  }

  // // called just before the Controller is deleted from memory
  @override
  void onClose() {
    super.onClose();
    _pageController.dispose();
  }

  void checkAns(Question question, int selectedIndex) {
    // because once user press any option then it will run
    _isAnswered = true;
    _selectedAns = selectedIndex;

    _score.value = _score.value + _selectedAns;
    // print(_score.value);
    update();

    // Once user select an ans after 3s it will go to the next qn
    Future.delayed(const Duration(seconds: 1), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    if (_questionNumber.value != _questions.length) {
      _isAnswered = false;
      _pageController.nextPage(
          duration: const Duration(milliseconds: 100), curve: Curves.ease);
    } else {
      // Get package provide us simple way to naviigate another page
      Get.to(CustomDialog(
          title: 'You got: ${_score.value} ',
          description:
              "Interpretation of Total Score:\n \n 1-4: Minimal depression. \n 5-9: Mild depression. \n 10-14: Moderate depression \n 15-19: Moderately severe depression \n 20-27: Severe depression"));
      // Get.to(Dashboard());
    }
  }

  int updateTheQnNum(int index) {
    _questionNumber.value = index + 1;
    return _questionNumber.value;
  }
}
