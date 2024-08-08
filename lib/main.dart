import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:yccetpc/screen/Campus/PracticeQuestion/aptitude_lr.dart';
import 'package:yccetpc/screen/Campus/PracticeQuestion/code.dart';
import 'package:yccetpc/screen/Campus/PracticeQuestion/interview_question.dart';
import 'package:yccetpc/screen/Campus/campus_screen.dart';
import 'package:yccetpc/screen/Home/home.dart';
import 'package:yccetpc/screen/Notification/notification_details.dart';
import 'package:yccetpc/screen/SignUP/login.dart';
import 'package:yccetpc/screen/coordinator/co_home.dart';
import 'package:yccetpc/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yccetpc/utils/material.dart';
import 'package:yccetpc/utils/push_notification_service.dart';
import 'firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // deleteAndResetDatabase();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PushNotificationService().initialize();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
     handleTapNotification(message);
});


   
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  InitializationSettings initializationSettings = const InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yashwant',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey, 
      home: const SplashScreen(),
      routes: {
        "/startup": (context) => LoginPage(),
        "/home": (context) => const HomeScreen(),
        "/coscreen": (context) => const CoHomeScreen(),
        "/campus":(context) => CampusScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/coding') {
           final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => PYQScreen(campusId: args?['campusId']),
          );
        } else if (settings.name == '/aptilr') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => AptitudeLRScreen(campusId: args?['campusId']),
          );
        }else if(settings.name == '/interview'){
           final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => InterviewQuestionScreen(campusId: args?['campusId']),
          );
        }else if(settings.name == '/notification'){
           final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => NotificationDetailsScreen(notificationId: args?['campusId']),
          );
        }
        return null; // Return null to fall back to the routes defined in `routes`
      },
    );
  }
}
