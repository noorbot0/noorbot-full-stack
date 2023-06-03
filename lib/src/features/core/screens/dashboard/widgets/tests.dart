import 'package:flutter/material.dart';
import 'package:noorbot_app/src/constants/colors.dart';

import '../../../models/dashboard/tests_model.dart';

class DashboardTests extends StatelessWidget {
  const DashboardTests({
    Key? key,
    required this.txtTheme,
  }) : super(key: key);

  final TextTheme txtTheme;

  @override
  Widget build(BuildContext context) {
    final list = DashboardTestsModel.list;

    void openTest(String testId) {
      print(testId);
    }

    return SizedBox(
      height: 65,
      child: ListView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => openTest(list[index].title), //list[index].onPress,
          child: SizedBox(
            width: 200,
            height: 65,
            child: Row(
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: tDarkColor),
                  child: Center(
                    child: Text(list[index].title,
                        style: txtTheme.titleLarge?.apply(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(list[index].heading,
                          style: txtTheme.titleLarge,
                          overflow: TextOverflow.visible),
                      Text(list[index].subHeading,
                          style: txtTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
