import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noorbot_app/src/constants/colors.dart';
import 'package:noorbot_app/src/constants/firestore_constants.dart';
import 'package:noorbot_app/src/constants/text_strings.dart';
import 'package:noorbot_app/src/features/core/screens/tracker/sentiment_provider.dart';
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
  late final SentimentProvider sentimentProvider =
      context.read<SentimentProvider>();
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
    setState(() {
      isLoading = true;
    });
    listMessage = await sentimentProvider.getSentiments(
        _auth.currentUser!.uid, chatRoomId);
    if (listMessage.isEmpty) {
      setState(() {
        noSentiment = true;
      });
    } else {
      // double xDay = 0;
      // DateTime ref = DateTime.now().subtract(const Duration(days: 30));
      // for (var day in listMessage) {
      //   double x = xDay;
      //   double y = double.parse(sentimentProvider
      //       .calculateNetSentimentScore(day)
      //       .toStringAsFixed(3));
      //   print("$x, $y");
      //   sentimentSpots.add(FlSpot(x, y));
      //   xDay++;
      //   ref = ref.add(const Duration(days: 1));
      // }
      DateTime prev = DateTime.now().subtract(const Duration(days: 30));
      for (var i = 1, j = 0; i < 30; i++) {
        DateTime date = DateTime.now().toUtc();
        if (j < listMessage.length) {
          date = DateFormat("MM_dd_yyyy")
              .parse(listMessage[j][FirestoreConstants.date]);
        }
        Duration diff = date.difference(prev);
        double x = i * 1.0;
        double y = 0;
        if (j < listMessage.length && diff.inDays == 0) {
          y = double.parse(sentimentProvider
              .calculateNetSentimentScore(listMessage[j])
              .toStringAsFixed(3));

          j++;
        }
        if (j >= listMessage.length &&
            diff.inDays == 0 &&
            (date.compareTo(DateTime.now().toUtc()) == 0)) {
          break;
        }
        // print("$x, $y");
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
        ? myChart(chartData, sentimentSpots)
        : const Center(
            child: Text(
            NoSentimentAnalysisMessage,
            textAlign: TextAlign.center,
          ));
  }

  Widget myChart(Function lineChartData, List<FlSpot> allSpots) {
    const List<Color> gradientColors = [
      AppColors.backgroundOne,
      AppColors.backgroundThree
    ];
    return !isLoading
        ? Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Center(
              child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: gradientColors.first,
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 0),
                      ),
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: gradientColors),
                  ),
                  width: 420,
                  height: 280,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 370,
                          height: 220,
                          child: LineChart(
                            lineChartData(allSpots),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        width: 375,
                        height: 20,
                        child: Center(
                          child: Text(
                            netSentimentAnalysisGraphSubtitle,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
  }

  LineChartData chartData(List<FlSpot> allSpots) {
    List<Color> gradientColors = [
      AppColors.underLineOne,
      AppColors.underLineTwo,
    ];
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 0.25,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 5,
            // getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 0.5,
            // getTitlesWidget: leftTitleWidgets,
            reservedSize: 40,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border.fromBorderSide(
            BorderSide(width: 0.5, color: AppColors.backgroundOne)),
      ),
      minX: 1,
      maxX: 30,
      minY: -1,
      maxY: 1,
      lineBarsData: [
        LineChartBarData(
          spots: allSpots,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case -1:
        text = const Text('MAR', style: style);
        break;
      default:
        text = Text("${value.toInt()}", style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case -1:
        text = '-1';
        break;
      case 0:
        text = '0';
        break;
      case 1:
        text = '1';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }
}
