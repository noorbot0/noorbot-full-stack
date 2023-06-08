import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:noorbot_app/src/constants/colors.dart';
import 'package:noorbot_app/src/constants/text_strings.dart';
import 'package:noorbot_app/src/features/core/screens/profile/profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HotLines extends StatelessWidget {
  const HotLines({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.to(const ProfileScreen()),
            icon: const Icon(LineAwesomeIcons.angle_left)),
        title: Text(tMenu4, style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          CardItem(
            title: 'Dr.Twfiq Sleman',
            subtitles: ['Subtitle 1', 'Subtitle 2'],
            phoneNumber: '022767888',
          ),
          CardItem(
            title: 'Dr.Samah Jabr',
            subtitles: ['Subtitle 1', 'Subtitle 2'],
            phoneNumber: '+970546981772',
          ),
          CardItem(
            title: 'Dr.Samah Jabr',
            subtitles: ['Subtitle 1', 'Subtitle 2'],
            phoneNumber: '+970546981772',
          ),
          CardItem(
            title: 'Dr.Samah Jabr',
            subtitles: ['Subtitle 1', 'Subtitle 2'],
            phoneNumber: '+970546981772',
          ),
        ],
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final String title;
  final List<String> subtitles;
  final String phoneNumber;

  const CardItem({
    Key? key,
    required this.title,
    required this.subtitles,
    required this.phoneNumber,
  }) : super(key: key);

  void _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      Get.snackbar("Sorry", "Could not launch phone");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.location_on, color: tmainGreenColor),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final subtitle in subtitles) Text(subtitle),
            GestureDetector(
              onTap: () => _launchPhone(phoneNumber),
              child: Text(
                phoneNumber,
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.person, color: tmainGreenColor),
      ),
    );
  }
}
// contentPadding: const EdgeInsets.fromLTRB(tDashboardCardPadding,
//                   tDefaultSize, tDashboardCardPadding, tDefaultSize),

