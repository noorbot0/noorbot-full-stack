import 'package:noorbot_app/src/constants/image_strings.dart';

class DashboardTopCoursesModel {
  final String title;
  final String heading;
  final String subHeading;
  final String image;
  final String link;

  DashboardTopCoursesModel(
      this.title, this.heading, this.subHeading, this.image, this.link);

  static List<DashboardTopCoursesModel> list = [
    DashboardTopCoursesModel(
        "Reform anxios thoughts",
        "3 Sections",
        "Abed Breigth",
        tTopCourseImage1,
        "www.youtube.com/watch?v=VGIAbU_E244"),
    DashboardTopCoursesModel("Stop negative thinkig", "30 min", "Daniel Sleibi",
        tTopCourseImage2, "www.youtube.com/watch?v=iB_1jluDbpU"),
    DashboardTopCoursesModel(
        "Body appreciation meditation",
        "11 min",
        "Mays Quneibi",
        tTopCourseImage3,
        "www.youtube.com/watch?v=J4NivrOspZA"),
  ];
}
