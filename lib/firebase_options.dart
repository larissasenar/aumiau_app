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
    apiKey: 'AIzaSyD9Fm8eQAwx-k_M5sDF7YYhKuXjopdD178',
    appId: '1:720433006794:web:6b7325887c6005bedbcc33',
    messagingSenderId: '720433006794',
    projectId: 'aumiau-app',
    authDomain: 'aumiau-app.firebaseapp.com',
    storageBucket: 'aumiau-app.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCiJq7TmQ7vBA6KX7m_04ICkNQP_FkaYbE',
    appId: '1:720433006794:android:15989f6094b70031dbcc33',
    messagingSenderId: '720433006794',
    projectId: 'aumiau-app',
    storageBucket: 'aumiau-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCvLz0l_y1OqqO-micXjAVg5PR_TcTi7XU',
    appId: '1:720433006794:ios:d1ae7500d7d00d29dbcc33',
    messagingSenderId: '720433006794',
    projectId: 'aumiau-app',
    storageBucket: 'aumiau-app.firebasestorage.app',
    iosBundleId: 'com.example.aumiauApp',
  );

}