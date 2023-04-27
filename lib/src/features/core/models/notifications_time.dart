import 'package:flutter/material.dart';

class NotificationsTime {
  int? id;
  String? title;
  String? alarmDateTime;
  IconData? icon;
  int? gradientColorIndex;

  NotificationsTime(
      {this.id,
      this.title,
      this.alarmDateTime,
      this.icon,
      this.gradientColorIndex});
}
