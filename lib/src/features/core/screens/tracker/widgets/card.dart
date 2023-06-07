import 'package:flutter/material.dart';
import 'package:noorbot_app/src/constants/colors.dart';

class MyCard extends StatelessWidget {
  const MyCard({
    super.key,
    required this.title,
    required this.widget,
  });

  final String title;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    const List<Color> gradientColors = [cardBGColor, cardBGColor];
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: cardShadowColor,
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(0, 0),
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(10)),
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors),
      ),
      // width: 420,
      // height: 280,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10),
            // width: 375,
            // height: 20,
            child: Container(
              margin: const EdgeInsets.only(left: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: "RaleWay",
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 10, bottom: 10, right: 10, top: 20),
            child: SizedBox(
                // width: 370,
                // height: 220,
                child: widget),
          ),
          // const SizedBox(height: 10),
        ],
        // )
      ),
    );
  }
}
