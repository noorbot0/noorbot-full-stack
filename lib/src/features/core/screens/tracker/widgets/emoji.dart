import 'package:flutter/material.dart';
import 'package:noorbot_app/src/constants/colors.dart';

class Emoji extends StatelessWidget {
  const Emoji({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundColor: tWhiteColor,
        // decoration: const BoxDecoration(
        //   color: tWhiteColor,
        //   borderRadius: BorderRadius.all(
        //     Radius.circular(10),
        //   ),
        // ),
        child: RichText(
          text: _buildText(text),
        ));
  }

  TextSpan _buildText(String text) {
    final children = <TextSpan>[];
    final runes = text.runes;

    for (int i = 0; i < runes.length; /* empty */) {
      int current = runes.elementAt(i);

      // we assume that everything that is not
      // in Extended-ASCII set is an emoji...
      final isEmoji = current > 255;
      final shouldBreak = isEmoji ? (x) => x <= 255 : (x) => x > 255;

      final chunk = <int>[];
      while (!shouldBreak(current)) {
        chunk.add(current);
        if (++i >= runes.length) break;
        current = runes.elementAt(i);
      }

      children.add(
        TextSpan(
          text: String.fromCharCodes(chunk),
          style: TextStyle(
            fontFamily: isEmoji ? 'EmojiOne' : null,
          ),
        ),
      );
    }

    return TextSpan(children: children);
  }
}
