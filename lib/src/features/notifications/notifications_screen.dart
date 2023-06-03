import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'components/badge.dart';
import 'models/push_notification.dart';
import 'components/notification_card.dart';

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class NotificationsScreen extends StatefulWidget  {
  const NotificationsScreen({Key? key}) : super(key: key);
  @override
  NotificationsPageState createState() => NotificationsPageState();
}


class NotificationsPageState extends State {
  late final FirebaseMessaging _messaging;
  late int _totalNotifications;
  List<Widget> _notificationCards = [NotificationCard(title: "TEST TITLE", message: "TEST BODy",)];
  PushNotification? _notificationInfo;

  @override
  void initState() {

    _totalNotifications = 0;
    registerNotification();

    checkForInitialMessage();
    // For handling notification when the app is in background
    // but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );
      setState(() {
        _notificationInfo = notification;
        _notificationCards.add(NotificationCard(title: _notificationInfo!.title!, message: _notificationInfo!.body!,));
        _totalNotifications++;
      });
    });

    super.initState();
  }

  // For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
      );
      setState(() {
        _notificationInfo = notification;
        _notificationCards.add(NotificationCard(title: _notificationInfo!.title!, message: _notificationInfo!.body!,));
        _totalNotifications++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body:SingleChildScrollView( child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: _notificationCards
      )),
    );
  }

  void registerNotification() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp();


    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;
    _messaging.subscribeToTopic('morning');
    _messaging.subscribeToTopic('day');
    _messaging.subscribeToTopic('evening');
    _messaging.subscribeToTopic('night');



    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    String? token = await _messaging.getToken();
    print('Registration Token=$token');

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      // For handling the received notifications

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );

        setState(() {
          _notificationInfo = notification;
          _notificationCards.add(NotificationCard(title: _notificationInfo!.title!, message: _notificationInfo!.body!));
          _totalNotifications++;
        });
        if (_notificationInfo != null) {
          // For displaying the notification as an overlay
          showSimpleNotification(
            Text(_notificationInfo!.title!),
            leading: NotificationBadge(totalNotifications: _totalNotifications),
            subtitle: Text(_notificationInfo!.body!),
            background: Colors.cyan.shade700,
            duration: const Duration(seconds: 5),
          );
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }
}