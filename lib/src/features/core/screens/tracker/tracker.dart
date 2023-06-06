import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noorbot_app/src/constants/firestore_constants.dart';
import 'package:noorbot_app/src/constants/sizes.dart';
import 'package:noorbot_app/src/constants/text_strings.dart';
import 'package:noorbot_app/src/features/core/models/chat/analysis.dart';
import 'package:noorbot_app/src/features/core/providers/logger_provider.dart';
import 'package:noorbot_app/src/features/core/providers/tracker_provider.dart';
import 'package:noorbot_app/src/features/core/screens/dashboard/widgets/appbar.dart';
import 'package:noorbot_app/src/features/core/screens/tracker/widgets/my_chart.dart';
import 'package:noorbot_app/src/features/core/screens/tracker/widgets/my_daily_chart.dart';
import 'package:noorbot_app/src/features/core/screens/tracker/widgets/my_pie_chart.dart';
import 'package:noorbot_app/src/features/core/screens/tracker/widgets/rank.dart';
import 'package:noorbot_app/src/features/core/screens/tracker/widgets/ranking.dart';
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
  bool isOverallLoading = true;
  bool noSentiment = false;
  double posValue = 0;
  double negValue = 0;
  double neuValue = 0;

  @override
  void initState() {
    super.initState();
    chatRoomId = _auth.currentUser!.uid;
    prepareDailySentimentAnalysis();
    prepareOverallSentimentAnalysis();
  }

  void prepareDailySentimentAnalysis() async {
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

  void prepareOverallSentimentAnalysis() async {
    log.info("Prepare overall sentiments analysis for chatId($chatRoomId)...");
    setState(() {
      isOverallLoading = true;
    });
    void errCallback(String errMsg) {
      log.error("Error when fetching overall sentiments with msg($errMsg)");
    }

    Analysis overall = await sentimentProvider.getOverallSentimentsAnalysis(
        _auth.currentUser!.uid, chatRoomId, errCallback);

    posValue = overall.sentimentPositive * 100.0 / overall.messagesNumber;
    neuValue = overall.sentimentNeutral * 100.0 / overall.messagesNumber;
    negValue = overall.sentimentNegative * 100.0 / overall.messagesNumber;
    List<Rank> topRanks = [];
    Map<String, int> top5 = {};
    overall.sentiments.forEach(
      (key, value) {
        // top5.
      },
    );
    // for (var el in overall.sentiments.entries) {

    // }
    setState(() {
      isOverallLoading = false;
    });
  }

  // Added total messages in overall
  // full day analysis
  // top used sentiments with emojies

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        appBar: DashboardAppBar(
          isDark: isDark,
          topTitle: tTrackingPageName,
        ),
        body: !isLoading && !isOverallLoading
            ? SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(tDashboardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //sentimentsChartSection
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: MyRankChart(subtitle: "Rank Chart"),
                          ),
                          const SizedBox(width: tDashboardPadding),

                          Flexible(
                            child: overallSentimentsChartSection(),
                          )
                          // overallSentimentsChartSection()
                        ],
                      ),
                      const SizedBox(height: tDashboardPadding),

                      !noSentiment
                          ? MyDailyChart(
                              lineChartData: MyDailyChart.chartData,
                              allSpots: sentimentSpots,
                              subtitle: netSentimentAnalysisGraphSubtitle,
                            )
                          : const Center(
                              child: Text(
                                noSentimentAnalysisMessage,
                                textAlign: TextAlign.center,
                              ),
                            ),
                      // overallSentimentsChartSection(),
                      const SizedBox(height: tDashboardPadding),

                      sentimentsChartSection(),
                      const SizedBox(height: tDashboardPadding),
                    ],
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              ),
      ),
    );
  }

  Widget sentimentsChartSection() {
    return !noSentiment
        ? MyChart(
            lineChartData: MyChart.chartData,
            allSpots: sentimentSpots,
            subtitle: netSentimentAnalysisGraphSubtitle,
          )
        : const Center(
            child: Text(
              noSentimentAnalysisMessage,
              textAlign: TextAlign.center,
            ),
          );
  }

  overallSentimentsChartSection() {
    return MyPieChart(
      subtitle: overallAnalysisGraphSubtitle,
      negativeValue: negValue,
      neutralValue: neuValue,
      positiveValue: posValue,
    );
  }
}
