import 'package:flutter/material.dart';

import '../../../../../constants/image_strings.dart';

class ImageWithIcon extends StatelessWidget {
  const ImageWithIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: const Image(image: AssetImage(tChatImage)),
          ),
        ),
      ],
    );
  }
}
