import 'package:noorbot_app/src/constants/image_strings.dart';

class DashboardTopCoursesModel {
  final String title;
  final String heading;
  final String image;
  final String link;

  DashboardTopCoursesModel(this.title, this.heading, this.image, this.link);

  static List<DashboardTopCoursesModel> list = [
    DashboardTopCoursesModel("Reform anxios thoughts", "3 Sections",
        tTopCourseImage1, "https://www.youtube.com/watch?v=VGIAbU_E244"),
    DashboardTopCoursesModel("Stop negative thinkig", "30 min",
        tTopCourseImage2, "https://www.youtube.com/watch?v=iB_1jluDbpU"),
    DashboardTopCoursesModel("Body appreciation meditation", "11 min",
        tTopCourseImage3, "https://www.youtube.com/watch?v=J4NivrOspZA"),
  ];
}
