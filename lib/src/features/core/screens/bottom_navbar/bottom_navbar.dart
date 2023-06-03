import 'package:flutter/material.dart';
import 'package:noorbot_app/src/features/core/providers/logger_provider.dart';
import 'package:noorbot_app/src/features/core/screens/chat/chat.dart';
import 'package:noorbot_app/src/features/core/screens/dashboard/dashboard.dart';
import 'package:noorbot_app/src/features/core/screens/tracker/tracker.dart';
import 'package:noorbot_app/src/features/journaling/screens/journaling_screen.dart';
import 'package:noorbot_app/src/features/notifications/notifications_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class MyNavBar extends StatefulWidget {
  const MyNavBar({Key? key}) : super(key: key);

  @override
  NavBar createState() => NavBar();
}

class NavBar extends State<MyNavBar> {
  int selectedIndex = 2;
  late final LoggerProvider log = context.read<LoggerProvider>();

  static const List<Widget> options = <Widget>[
    Tracker(),
    MyChat(),
    Dashboard(),
    Journaling(),
    NotificationsScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    log.info(
        "Navigating from ($selectedIndex: ${options[selectedIndex].toStringShort()}) to ($index: ${options[index].toStringShort()})");
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: options.elementAt(selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
            // bottomRight: Radius.circular(30),
            // bottomLeft: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
            // bottomLeft: Radius.circular(30.0),
            // bottomRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.track_changes_outlined),
                icon: Icon(Icons.track_changes),
                label: 'Tracking',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.message_outlined),
                icon: Icon(Icons.message),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.home_outlined),
                icon: Icon(Icons.home),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.book_outlined),
                icon: Icon(Icons.book),
                label: 'Journal',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.notifications_active_outlined),
                icon: Icon(Icons.notifications),
                label: 'Notifications',
              ),
            ],
            currentIndex: selectedIndex,
            onTap: _onItemTapped,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            selectedIconTheme: const IconThemeData(size: 30),
            unselectedIconTheme: const IconThemeData(size: 24),
          ),
        ),
      ),
    );
  }
}
