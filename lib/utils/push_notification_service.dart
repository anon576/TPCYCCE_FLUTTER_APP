
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:yccetpc/utils/material.dart';
import '../database/database.dart';


class PushNotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            'high_importance_channel', 
            'High Importance Notifications', 
            importance: Importance.max,
            playSound: true, 
          ),
        );



    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        await _handleNotification(message);
      } 
      _showNotification(message);
        handleTapNotification(message);
    });

   

  }

  Future<void> _handleNotification(RemoteMessage message) async {
    // Initialize the database helper
      DatabaseHelper db = DatabaseHelper();

    // Extract data from the RemoteMessage
    String? id = message.messageId;
    String? title = message.notification?.title;
    String? body = message.notification?.body;
    int? screen_id = int.parse(message.data['screen_id']);
    String? screen = message.data['screen'];

    // Store the message in the local database
    try {
      await db.insertNotification(id, title, body,screen_id,screen);
      print("Notification inserted into the local database.");
    } catch (e) {
      print("Error inserting notification into the database: $e");
    }
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel', // Ensure this matches the channel ID
      'High Importance Notifications', // Channel name
      importance: Importance.max,
      priority: Priority.high,
      playSound: true, // This will use the default notification sound
    );
    
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
    );
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize the database helper
   DatabaseHelper db = DatabaseHelper();

    // Extract data from the RemoteMessage
    String? id = message.messageId;
    String? title = message.notification?.title;
    String? body = message.notification?.body;
    int? screen_id = int.parse(message.data['screen_id']);
    String? screen = message.data['screen'];

    // Store the message in the local database
    try {
      await db.insertNotification(id, title, body,screen_id,screen);
      print("Notification inserted into the local database.");
    } catch (e) {
      print("Error inserting notification into the database: $e");
    }
}

void handleTapNotification(RemoteMessage message) {
  // Parse the payload data
  final data = message.data;
  final String? screen = data['screen'];
  final int? screen_id = int.parse(data['screen_id']);

  if (screen == '/campus') {
    // Navigate to the campus screen with optional data
    navigatorKey.currentState?.pushNamed('/campus');
  } else {
    // Navigate to the PYQScreen with campusId
    navigatorKey.currentState?.pushNamed('$screen', arguments: {'campusId': screen_id});
  } 
}

