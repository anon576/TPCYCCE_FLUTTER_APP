// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAvZqyX-xoXaLNJ0lp4RS5RqNC4uY3U61M',
    appId: '1:951046961721:web:af32cc7f942664c3e4ebe8',
    messagingSenderId: '951046961721',
    projectId: 'tpcycce',
    authDomain: 'tpcycce.firebaseapp.com',
    storageBucket: 'tpcycce.appspot.com',
    measurementId: 'G-7JF1JMHP08',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBoo1UKpPX3gCblxU77ktXF-WPQlaqsJ5g',
    appId: '1:951046961721:android:434d54688606db0be4ebe8',
    messagingSenderId: '951046961721',
    projectId: 'tpcycce',
    storageBucket: 'tpcycce.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCoXMANFTVXFCZgwB2Z-yiK9_oF71lzfdQ',
    appId: '1:951046961721:ios:9e7612b9ff53aa05e4ebe8',
    messagingSenderId: '951046961721',
    projectId: 'tpcycce',
    storageBucket: 'tpcycce.appspot.com',
    iosBundleId: 'com.example.yccetpc',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCoXMANFTVXFCZgwB2Z-yiK9_oF71lzfdQ',
    appId: '1:951046961721:ios:9e7612b9ff53aa05e4ebe8',
    messagingSenderId: '951046961721',
    projectId: 'tpcycce',
    storageBucket: 'tpcycce.appspot.com',
    iosBundleId: 'com.example.yccetpc',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAvZqyX-xoXaLNJ0lp4RS5RqNC4uY3U61M',
    appId: '1:951046961721:web:c96a65760c986b47e4ebe8',
    messagingSenderId: '951046961721',
    projectId: 'tpcycce',
    authDomain: 'tpcycce.firebaseapp.com',
    storageBucket: 'tpcycce.appspot.com',
    measurementId: 'G-6QTPL0C1KK',
  );
}
