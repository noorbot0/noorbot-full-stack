// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:noorbot_app/src/constants/colors.dart';
// import 'package:noorbot_app/src/constants/image_strings.dart';
// import 'package:noorbot_app/src/features/core/screens/tracker/widgets/emoji.dart';
// import 'package:noorbot_app/src/features/core/screens/tracker/widgets/rank.dart';

// class MyTodayChart extends StatefulWidget {
//   final String subtitle;
//   // final List<Rank> ranks;

//   const MyTodayChart({
//     super.key,
//     required this.subtitle,
//     // required this.ranks,
//   });

//   @override
//   TodayChart createState() => TodayChart();
// }

// class TodayChart extends State<MyTodayChart> {
//   int touchedIndex = -1;

//   @override
//   Widget build(BuildContext context) {
//     const List<Color> gradientColors = [rankBackgroundOne, rankBackgroundTwo];

//     return Container(
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: gradientColors.first,
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, 0),
//           ),
//         ],
//         borderRadius: const BorderRadius.all(Radius.circular(10)),
//         gradient: const LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: gradientColors),
//       ),
//       // width: 200,
//       height: 280,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.only(left: 10, right: 10),
//             // width: 200,
//             height: 220,
//             child: Column(
//               children: List.generate(
//                 5,
//                 (i) {
//                   return Flexible(
//                     child: Container(
//                       margin: const EdgeInsets.only(top: 5),
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         color:
//                             rankRanksColor.withOpacity(((4 - i) / 10.0) + 0.6),
//                         boxShadow: [
//                           BoxShadow(
//                             color: kBlackColor.withOpacity(0.5),
//                             blurRadius: 10,
//                             spreadRadius: 0.5,
//                           )
//                         ],
//                         // border: Border.all(
//                         //   width: 1,
//                         // ),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             // dense: true,
//                             // visualDensity:
//                             //     const VisualDensity(horizontal: 0, vertical: -4),
//                             // leading:
//                             Expanded(
//                               flex: 4,
//                               // width: 30,
//                               child: Padding(
//                                   padding:
//                                       const EdgeInsets.only(top: 5, bottom: 5),
//                                   child: MyEmoji(text: widget.ranks[i].emoji)),
//                             ),
//                             // title:
//                             Expanded(
//                               flex: 6,
//                               child: Text(
//                                 widget.ranks[i].name,
//                                 textAlign: TextAlign.left,
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             // trailing:
//                             Expanded(
//                               flex: 3,
//                               child: Text("#${widget.ranks[i].number}"),
//                             ),
//                           ]),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           SizedBox(
//             // width: 200,
//             height: 20,
//             child: Center(
//               child: Text(
//                 widget.subtitle,
//                 textAlign: TextAlign.right,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           )
//         ],
//         // )
//       ),
//     );
//   }

//   List<PieChartSectionData> showingSections(
//       double positiveValue, double neutralValue, double negativeValue) {
//     return List.generate(5, (i) {
//       final isTouched = i == touchedIndex;
//       final fontSize = isTouched ? 18.0 : 14.0;
//       final radius = isTouched ? 75.0 : 65.0;
//       final widgetSize = isTouched ? 55.0 : 30.0;
//       const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

//       switch (i) {
//         case 0:
//           return PieChartSectionData(
//             color: oaPosSectorColor,
//             value: positiveValue,
//             title: '${positiveValue.toStringAsFixed(0)}%',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: const Color(0xffffffff),
//               shadows: shadows,
//             ),
//             badgeWidget: _Badge(
//               tChartHappyFaceImage,
//               size: widgetSize,
//               borderColor: mainGridLineColor,
//             ),
//             badgePositionPercentageOffset: 1.1,
//           );
//         case 1:
//           return PieChartSectionData(
//             color: oaNeuSectorColor,
//             value: neutralValue,
//             title: '${neutralValue.toStringAsFixed(0)}%',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: const Color(0xffffffff),
//               shadows: shadows,
//             ),
//             badgeWidget: _Badge(
//               tChartNeutralFaceImage,
//               size: widgetSize,
//               borderColor: mainGridLineColor,
//             ),
//             badgePositionPercentageOffset: 1.1,
//           );
//         case 2:
//           return PieChartSectionData(
//             color: oaNegSectorColor,
//             value: negativeValue,
//             title: '${negativeValue.toStringAsFixed(0)}%',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: const Color(0xffffffff),
//               shadows: shadows,
//             ),
//             badgeWidget: _Badge(
//               tChartSadFaceImage,
//               size: widgetSize,
//               borderColor: mainGridLineColor,
//             ),
//             badgePositionPercentageOffset: 1.1,
//           );
//         default:
//           throw Exception('Oh no');
//       }
//     });
//   }
// }

// class _Badge extends StatelessWidget {
//   const _Badge(
//     this.svgAsset, {
//     required this.size,
//     required this.borderColor,
//   });
//   final String svgAsset;
//   final double size;
//   final Color borderColor;

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: PieChart.defaultDuration,
//       width: size,
//       height: size,
//       constraints: BoxConstraints.expand(height: size),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: borderColor,
//           width: 0,
//         ),
//         boxShadow: <BoxShadow>[
//           BoxShadow(
//             color: Colors.black.withOpacity(.5),
//             offset: const Offset(3, 3),
//             blurRadius: 3,
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(0),
//       child: Center(
//         child: SizedBox(
//           child: SvgPicture.asset(
//             svgAsset,
//           ),
//         ),
//       ),
//     );
//   }
// }
