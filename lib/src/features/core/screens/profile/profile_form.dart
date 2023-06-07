import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../../authentication/models/user_model.dart';
import '../../controllers/profile_controller.dart';

class ProfileFormScreen extends StatelessWidget {
  const ProfileFormScreen({
    Key? key,
    required this.nickname,
    required this.email,
    required this.password,
    required this.user,
  }) : super(key: key);

  final TextEditingController nickname;
  final TextEditingController email;
  final TextEditingController password;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: nickname,
            decoration: const InputDecoration(
                label: Text(tNickname),
                prefixIcon: Icon(LineAwesomeIcons.user)),
          ),
          const SizedBox(height: tFormHeight - 20),
          TextFormField(
            controller: email,
            decoration: const InputDecoration(
                label: Text(tEmail),
                prefixIcon: Icon(LineAwesomeIcons.envelope_1)),
          ),
          const SizedBox(height: tFormHeight - 20),
          TextFormField(
            controller: password,
            obscureText: true,
            decoration: InputDecoration(
              label: const Text(tPassword),
              prefixIcon: const Icon(Icons.fingerprint),
              suffixIcon: IconButton(
                  icon: const Icon(LineAwesomeIcons.eye_slash),
                  onPressed: () {}),
            ),
          ),
          const SizedBox(height: tFormHeight),

          /// -- Form Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final userData = UserModel(
                  id: user.id,
                  email: email.text.trim(),
                  password: password.text.trim(),
                  nickname: nickname.text.trim(),
                );

                await controller.updateRecord(userData);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: tmainGreenColor,
                  side: BorderSide.none,
                  shape: const StadiumBorder()),
              child:
                  const Text(tEditProfile, style: TextStyle(color: tDarkColor)),
            ),
          ),
          const SizedBox(height: tDefaultSize),

          /// -- Created Delete Button

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await controller.deleteUser();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: kRedColor,
                  side: BorderSide.none,
                  shape: const StadiumBorder()),
              child: const Text(tDelete, style: TextStyle(color: tWhiteColor)),
            ),
          ),
        ],
      ),
    );
  }
}
