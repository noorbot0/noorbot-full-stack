import 'package:flutter/material.dart';
import 'package:noorbot_app/src/constants/image_strings.dart';

class DashboardTopCoursesModel {
  final String title;
  final String heading;
  final String subHeading;
  final String image;
  final VoidCallback? onPress;

  DashboardTopCoursesModel(
      this.title, this.heading, this.subHeading, this.image, this.onPress);

  static List<DashboardTopCoursesModel> list = [
    DashboardTopCoursesModel("Reform anxios thoughts", "3 Sections",
        "Abed Breigth", tTopCourseImage1, () {}),
    DashboardTopCoursesModel("Stop negative thinkig", "30 min", "Daniel Sleibi",
        tTopCourseImage2, null),
    DashboardTopCoursesModel("Body appreciation meditation", "6 Sections",
        "Mays Quneibi", tTopCourseImage3, () {}),
  ];
}
