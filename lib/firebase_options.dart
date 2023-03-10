// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
// / Example:
// / ```dart
// / import 'firebase_options.dart';
// / // ...
// / await Firebase.initializeApp(
// /   options: DefaultFirebaseOptions.currentPlatform,
// / );
// / ```
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBfcPzZAYx4POp9qcwOKo40rcZ96sBF0oQ',
    appId: '1:150267985187:web:74841b53a558d7576f6096',
    messagingSenderId: '150267985187',
    projectId: 'art-market-c662c',
    authDomain: 'art-market-c662c.firebaseapp.com',
    storageBucket: 'art-market-c662c.appspot.com',
    measurementId: 'G-CRDS7BW9Z3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCJLiTje80_BPyVtvp7DjowAOffzo5Ol84',
    appId: '1:150267985187:android:fc6a0341db7a26746f6096',
    messagingSenderId: '150267985187',
    projectId: 'art-market-c662c',
    storageBucket: 'art-market-c662c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAk611ve4zuiTI1lC6b6WdmEzNWU7Ru5e8',
    appId: '1:150267985187:ios:4833627d8f3c17f76f6096',
    messagingSenderId: '150267985187',
    projectId: 'art-market-c662c',
    storageBucket: 'art-market-c662c.appspot.com',
    iosClientId:
        '150267985187-mb8dt2bk382j6189o033tl5pfuan1jlf.apps.googleusercontent.com',
    iosBundleId: 'com.example.artMarket',
  );
}
