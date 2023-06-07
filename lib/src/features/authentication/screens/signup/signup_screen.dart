import 'package:flutter/material.dart';
import 'package:noorbot_app/src/constants/image_strings.dart';
import 'package:noorbot_app/src/constants/text_strings.dart';
import 'package:noorbot_app/src/features/authentication/screens/signup/widgets/signup_footer_widget.dart';
import 'package:noorbot_app/src/features/authentication/screens/signup/widgets/signup_form_widget.dart';

import '../../../../common_widgets/form/form_header_widget.dart';
import '../../../../constants/sizes.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: const Column(
              children: [
                FormHeaderWidget(
                  image: tWelcomeLogoImage,
                  title: tSignUpTitle,
                  subTitle: tSignUpSubTitle,
                  // imageHeight: 0.1,
                ),
                SignUpFormWidget(),
                SignUpFooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
