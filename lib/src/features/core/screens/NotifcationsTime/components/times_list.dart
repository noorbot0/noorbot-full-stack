import 'package:flutter/material.dart';
import '../../../../../constants/colors.dart';
import '../../../models/notifications_time.dart';

class TimesList extends StatelessWidget {
  const TimesList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<NotificationsTime> notificationsTimes = [
      NotificationsTime(
          alarmDateTime: "6:00AM - 10:00AM",
          title: 'Morning',
          icon: Icons.sunny,
          gradientColorIndex: 0),
      NotificationsTime(
          alarmDateTime: "10:00AM - 5:00PM",
          title: 'Day',
          icon: Icons.cloud,
          gradientColorIndex: 1),
      NotificationsTime(
          alarmDateTime: "5:00PM - 8:00PM",
          title: 'Evening',
          icon: Icons.bedtime,
          gradientColorIndex: 2),
      NotificationsTime(
          alarmDateTime: "8:00PM - 11:00PM",
          title: 'Night',
          icon: Icons.bed,
          gradientColorIndex: 3),
    ];
    String notifications_time = 'Evening';
    
    return SizedBox(
        height: 450,
        width: 300,
        child: Column(
          children: [
            Expanded(
                child: ListView(
              children: notificationsTimes.map((time) {
                var gradientColor = GradientTemplate
                    .gradientTemplate[time.gradientColorIndex!].colors;
                IconData? icon = time.icon;
                return Container(
                  margin: const EdgeInsets.only(bottom: 5, top: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColor,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: gradientColor.last.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: const Offset(4, 4),
                      ),
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(24)),
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              new Icon(
                                icon,
                                color: Colors.white,
                                size: 24,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                time.title!,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'avenir',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                          Switch(
                            onChanged: (bool value) {},
                            value: true,
                            activeColor: Colors.white,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            time.alarmDateTime!,
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'avenir',
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ))
          ],
        ));
  }
}
