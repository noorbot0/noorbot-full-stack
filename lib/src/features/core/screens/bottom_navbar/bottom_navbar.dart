import 'package:flutter/material.dart';
import 'package:noorbot_app/src/features/core/screens/chat/chat.dart';
import 'package:noorbot_app/src/features/core/screens/dashboard/dashboard.dart';
import 'package:noorbot_app/src/features/journaling/screens/journaling_screen.dart';

import 'package:noorbot_app/src/features/core/screens/tracker/tracker.dart';

import 'package:noorbot_app/src/features/notifications/notifications_screen.dart';

class MyNavBar extends StatefulWidget {
  const MyNavBar({super.key});

  @override
  State<MyNavBar> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyNavBar> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    MyChat(),
    Tracker(),
    NotificationsScreen(),
    Journaling()

  ];

  void _onItemTapped(int index) {
    setState(() {
      print('NavBar tapped item index: ${index} : ${_widgetOptions.length}');
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
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
                activeIcon: Icon(Icons.home_outlined),
                icon: Icon(Icons.home),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.message_outlined),
                icon: Icon(Icons.message),
                label: 'Chat',
              ),
              BottomNavigationBarItem(

                activeIcon: Icon(Icons.track_changes_outlined),
                icon: Icon(Icons.track_changes),
                label: 'Tracking',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.notifications_active_outlined),
                icon: Icon(Icons.notifications),
                label: 'Notifications',),
  BottomNavigationBarItem(
                activeIcon: Icon(Icons.book_outlined),
                icon: Icon(Icons.book),
                label: 'Journal',

              )
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: [
              // const Color.fromARGB(255, 19, 198, 88),
              const Color.fromARGB(255, 52, 109, 225),
              const Color.fromARGB(255, 52, 109, 225),
              const Color.fromARGB(255, 52, 109, 225),
  const Color.fromARGB(255, 52, 109, 225),
              const Color.fromARGB(255, 52, 109, 225)


            ][_selectedIndex],
            onTap: _onItemTapped,
            showSelectedLabels: false,
            showUnselectedLabels: false,
          ),
        ),
      ),
    );
  }
}
