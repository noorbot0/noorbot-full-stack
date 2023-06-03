import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noorbot_app/src/constants/firestore_constants.dart';
import 'package:noorbot_app/src/constants/text_strings.dart';
import 'package:noorbot_app/src/features/core/providers/logger_provider.dart';
import 'package:noorbot_app/src/features/core/providers/tracker_provider.dart';
import 'package:noorbot_app/src/features/core/screens/tracker/widgets/my_chart.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class Tracker extends StatefulWidget {
  const Tracker({Key? key}) : super(key: key);

  @override
  MyTracker createState() => MyTracker();
}

class MyTracker extends State<Tracker> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String chatRoomId;
  late final TrackerProvider sentimentProvider =
      context.read<TrackerProvider>();
  late final LoggerProvider log = context.read<LoggerProvider>();

  List<Map<String, dynamic>> listMessage = [];
  List<FlSpot> sentimentSpots = [];
  bool isLoading = true;
  bool noSentiment = false;

  @override
  void initState() {
    super.initState();
    chatRoomId = _auth.currentUser!.uid;
    prepareSentimentAnalysis();
  }

  void prepareSentimentAnalysis() async {
    log.info("Prepare sentiments analysis for chatId($chatRoomId)...");
    // setState(() {
    //   isLoading = true;
    // });
    void errCallback(String errMsg) {
      log.error("Error when fetching sentiments with msg($errMsg)");
    }

    listMessage = await sentimentProvider.getSentiments(
        _auth.currentUser!.uid, chatRoomId, errCallback);
    if (listMessage.isEmpty) {
      setState(() {
        noSentiment = true;
      });
    } else {
      DateTime prev = DateFormat("MM_dd_yyyy")
          .parse(
              "${DateTime.now().month}_${DateTime.now().day}_${DateTime.now().year}")
          .subtract(const Duration(days: 30));

      for (var i = 0, j = 0; i < 31; i++) {
        DateTime date = DateTime.now();
        if (j < listMessage.length) {
          date = DateFormat("MM_dd_yyyy")
              .parse(listMessage[j][FirestoreConstants.date]);
        }
        Duration diff = date.difference(prev);
        double x = i * 1.0;
        double y = 0;
        if (j < listMessage.length) {
          if (diff.inDays == 0) {
            y = double.parse(sentimentProvider
                .calculateNetSentimentScore(listMessage[j])
                .toStringAsFixed(3));

            j++;
          } else if (diff.inDays < 0) {
            j++;
            if (i == 0 || i == 1) {
              i = 0;
            } else {
              i--;
            }
            continue;
          }
        }
        if (j >= listMessage.length &&
            diff.inDays == 0 &&
            (date.compareTo(DateTime.now().toUtc()) == 0)) {
          break;
        }
        prev = prev.add(const Duration(days: 1));
        sentimentSpots.add(FlSpot(x, y));
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !noSentiment
        ? !isLoading
            ? MyChart(
                lineChartData: MyChart.chartData,
                allSpots: sentimentSpots,
                subtitle: netSentimentAnalysisGraphSubtitle,
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              )
        : const Center(
            child: Text(
              noSentimentAnalysisMessage,
              textAlign: TextAlign.center,
            ),
          );
  }
}
