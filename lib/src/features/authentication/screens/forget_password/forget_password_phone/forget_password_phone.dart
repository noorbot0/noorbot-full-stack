import 'package:flutter/material.dart';
import 'package:noorbot_app/src/constants/colors.dart';
import 'package:noorbot_app/src/constants/image_strings.dart';
import 'package:noorbot_app/src/constants/sizes.dart';
import 'package:noorbot_app/src/constants/text_strings.dart';
import '../../../../../common_widgets/form/form_header_widget.dart';

class ForgetPasswordPhoneScreen extends StatelessWidget {
  const ForgetPasswordPhoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Just In-case if you want to replace the Image Color for Dark Theme
    final brightness = MediaQuery.of(context).platformBrightness;
    final bool isDark = brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              children: [
                const SizedBox(height: tDefaultSize * 4),
                FormHeaderWidget(
                  imageColor: isDark ? tPrimaryColor : tSecondaryColor,
                  image: tForgetPasswordImage,
                  title: tForgetPassword,
                  subTitle: tForgetPasswordSubTitle,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30.0,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: tFormHeight),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text(tPhoneNo),
                          hintText: tPhoneNo,
                          prefixIcon: Icon(Icons.numbers),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {},
                            child: const Text(tNext)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
