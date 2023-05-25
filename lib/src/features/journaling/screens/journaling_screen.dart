import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noorbot_app/src/features/core/screens/dashboard/dashboard.dart';
import 'package:noorbot_app/src/features/journaling/models/journal_model.dart';
import 'package:noorbot_app/src/features/journaling/screens/components/journal_card.dart';
import 'package:noorbot_app/src/features/journaling/screens/journal_screen.dart';
import '../../../constants/sizes.dart';
import '../../../constants/text_strings.dart';
import '../../core/screens/dashboard/widgets/appbar.dart';
import 'package:noorbot_app/src/features/journaling/controllers/journals_controller.dart';

class Journaling extends StatefulWidget {
  const Journaling({Key? key}) : super(key: key);
  @override
  _JournalingState createState() => _JournalingState();
}


class _JournalingState extends State<Journaling> {
late FutureBuilder<List<JournalModel>> journalCards;
late JournalsController controller;
@override
void initState() {
  super.initState();

}

navigateToEditJournalScreen() async {
  await Get.to(TextEditorScreen(createdAt: Timestamp.now(), editEnabled: true));
  setState(() {

    journalCards = FutureBuilder<List<JournalModel>>(
      future: controller.getUserJournalsData(),
      builder:
          (BuildContext context, AsyncSnapshot<List<JournalModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while the data is being fetched
          return ListView(children: const [CircularProgressIndicator()]);
        } else if (snapshot.hasError) {
          // Handle any errors that occurred during data fetching

          return Text('Error: ${snapshot.error}');
        } else {
          // Data fetching is complete, map the list of JournalModel objects to widgets
          List<JournalModel> journalList = snapshot.data!;
          return ListView.builder(
            itemCount: journalList.length,
            itemBuilder: (BuildContext context, int index) {
              return JournalCard(title: journalList[index].title ,createdAt: journalList[index].createdAt);
            },
          );
        }
      },
    );
});
}

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
     controller = Get.put(JournalsController());

    // final journals = controller.getUserJournalsData() as List<JournalModel>;

    journalCards = FutureBuilder<List<JournalModel>>(
      future: controller.getUserJournalsData(),
      builder:
          (BuildContext context, AsyncSnapshot<List<JournalModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while the data is being fetched
          return ListView(children: const [CircularProgressIndicator()]);
        } else if (snapshot.hasError) {
          // Handle any errors that occurred during data fetching

          return Text('Error: ${snapshot.error}');
        } else {
          // Data fetching is complete, map the list of JournalModel objects to widgets
          List<JournalModel> journalList = snapshot.data!;
          return ListView.builder(
            itemCount: journalList.length,
            itemBuilder: (BuildContext context, int index) {
              return JournalCard(title: journalList[index].title ,createdAt: journalList[index].createdAt);
            },
          );
        }
      },
    );
    // final journalsCard = ListView.builder(
    //   itemCount: journals.length,
    //   itemBuilder: (BuildContext context, int index) {
    //     return JournalCard(created_at: journals[index].createdAt);
    //   },
    // );
    return SafeArea(child:

         Scaffold(
            appBar: DashboardAppBar(
              isDark: isDark,
            ),
            body:Container(
                padding: const EdgeInsets.all(tDashboardPadding),
                child: Column(
                  children: [
                    Text(tJournaling, style: txtTheme.bodyMedium),
                    Expanded(child: journalCards),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => {
                              navigateToEditJournalScreen()
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //     content: Text('Feature Not Implemented'),
                              //     duration: Duration(seconds: 2),
                              //   ),
                              // )
                            },
                            child:
                            Text(tCreateOrEditTodayJournal.toUpperCase()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ))));
  }

}
