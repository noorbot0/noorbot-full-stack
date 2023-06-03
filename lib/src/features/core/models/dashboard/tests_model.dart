import 'package:flutter/material.dart';

class DashboardTestsModel {
  final String title;
  final String heading;
  final String subHeading;
  final VoidCallback? onPress;

  DashboardTestsModel(this.title, this.heading, this.subHeading, this.onPress);

  static List<DashboardTestsModel> list = [
    DashboardTestsModel("BDI", "Beck Depression Inventory", "Start", null),
    DashboardTestsModel(
        "PHQ-9", "Patient Health Questionnaire 9", "Start", null),
    DashboardTestsModel("PG", "Personal growth", "Start", null),
    DashboardTestsModel("R", "Relastionships", "Start", null),
    DashboardTestsModel("S", "Sleep", "Start", null),
  ];
}
