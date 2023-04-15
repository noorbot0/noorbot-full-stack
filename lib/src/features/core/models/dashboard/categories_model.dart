import 'package:flutter/material.dart';

class DashboardCategoriesModel {
  final String title;
  final String heading;
  final String subHeading;
  final VoidCallback? onPress;

  DashboardCategoriesModel(
      this.title, this.heading, this.subHeading, this.onPress);

  static List<DashboardCategoriesModel> list = [
    DashboardCategoriesModel("M", "Mindfulness", "check-in", null),
    DashboardCategoriesModel("SE", "Self-esteem", "check-in", null),
    DashboardCategoriesModel("PG", "Personal growth", "check-in", null),
    DashboardCategoriesModel("R", "Relastionships", "check-in", null),
    DashboardCategoriesModel("S", "Sleep", "check-in", null),
  ];
}
