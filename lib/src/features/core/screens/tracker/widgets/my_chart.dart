import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:noorbot_app/src/constants/colors.dart';

class MyChart extends StatelessWidget {
  const MyChart({
    super.key,
    required this.lineChartData,
    required this.allSpots,
    required this.subtitle,
  });

  final Function lineChartData;
  final List<FlSpot> allSpots;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    const List<Color> gradientColors = [backgroundOne, backgroundThree];
    return
        // Padding(
        //   padding: const EdgeInsets.only(left: 20, right: 20),
        //   child:
        Container(
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
      // width: 420,
      height: 280,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SizedBox(
              // width: 370,
              height: 220,
              child: LineChart(
                lineChartData(allSpots),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            // width: 375,
            height: 20,
            child: Center(
              child: Text(
                subtitle,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
        // )
      ),
    );
  }

  static LineChartData chartData(List<FlSpot> allSpots) {
    List<Color> gradientColors = [
      underLineOne,
      underLineTwo,
    ];
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 0.25,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: mainGridLineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: mainGridLineColor,
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
            BorderSide(width: 0.5, color: backgroundOne)),
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
