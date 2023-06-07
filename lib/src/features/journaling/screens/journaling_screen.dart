import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noorbot_app/src/features/core/screens/dashboard/widgets/appbar.dart';
import 'package:noorbot_app/src/features/journaling/controllers/journals_controller.dart';
import 'package:noorbot_app/src/features/journaling/models/journal_model.dart';
import 'package:noorbot_app/src/features/journaling/screens/components/journal_card.dart';
import 'package:noorbot_app/src/features/journaling/screens/journal_screen.dart';

import '../../../constants/sizes.dart';
import '../../../constants/text_strings.dart';

class Journaling extends StatefulWidget {
  const Journaling({Key? key}) : super(key: key);

  @override
  State createState() => _JournalingState();
}

class _JournalingState extends State<Journaling> {
  late FutureBuilder<List<JournalModel>> journalCards;
  late JournalsController controller;
  late bool journalExists = false;

  @override
  void initState() {
    super.initState();
    controller = Get.put(JournalsController());
    controller.todayJournalExists().then((result) => {
          setState(() {
            journalExists = result;
          })
        });
  }

  mapJournalToCards() {
    journalCards = FutureBuilder<List<JournalModel>>(
      future: controller.getUserJournalsData(),
      builder:
          (BuildContext context, AsyncSnapshot<List<JournalModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while the data is being fetched
          return const Expanded(
              child: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          // Handle any errors that occurred during data fetching

          return Text('${snapshot.error}');
        } else {
          // Data fetching is complete, map the list of JournalModel objects to widgets
          List<JournalModel> journalList = snapshot.data!;
          return Expanded(
              child: ListView.builder(
            itemCount: journalList.length,
            itemBuilder: (BuildContext context, int index) {
              return JournalCard(
                  title: journalList[index].title,
                  createdAt: journalList[index].createdAt);
            },
          ));
        }
      },
    );
  }

  navigateToEditJournalScreen() async {
    await Get.to(
        () => TextEditorScreen(createdAt: Timestamp.now(), editEnabled: true));

    mapJournalToCards();
    final result = await controller.todayJournalExists();
    setState(() {
      journalExists = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    mapJournalToCards();

    return SafeArea(
        child: Scaffold(
            appBar: DashboardAppBar(
              isDark: isDark,
              topTitle: tJournalsPageName,
            ),
            // JournalsAppBar(
            //   isDark: isDark,
            // ),
            floatingActionButton: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.green.shade50,
                child: IconButton(
                  icon: journalExists
                      ? const Icon(Icons.edit)
                      : const Icon(Icons.add),
                  onPressed: () => {navigateToEditJournalScreen()},
                )),
            body: Container(
              padding: const EdgeInsets.all(tDashboardPadding),
              child: Column(
                children: [
                  Text(tJournaling, style: txtTheme.bodyMedium),
                  journalCards,
                ],
              ),
            )));
  }
}
