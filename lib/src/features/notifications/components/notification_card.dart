import 'package:flutter/material.dart';

class NotificationCard extends StatefulWidget {
  final String title;
  final String message;
  const NotificationCard(
      {super.key, required this.title, required this.message});

  @override
  NotificationCardState createState() => NotificationCardState();
}

class NotificationCardState extends State<NotificationCard> {
  // late String _title;
  // late String _message;
  @override
  void initState() {
    // _title = 'Unknown Title';
    // _message = 'Unknown Message';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: SizedBox(
          width: null,
          height: 125,
          child: Column(children: [
            Center(
                child: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.blue, // Text color
                fontSize: 24, // Font size
                fontWeight: FontWeight.bold, // Font weight
                fontStyle: FontStyle.normal, // Font style
                letterSpacing: 2, // Spacing between letters
                wordSpacing: 4, // Spacing between words
              ),
            )),
            Center(child: Text(widget.message))
          ]),
        ),
      ),
    );
  }
}
