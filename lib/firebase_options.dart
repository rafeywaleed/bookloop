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
    apiKey: 'AIzaSyBVsNJh3syEjEbXMsScA3vq78FZzFaJ5IU',
    appId: '1:1016944723693:web:bd84c4f4bab30329cfaee4',
    messagingSenderId: '1016944723693',
    projectId: 'bookloop-c1e49',
    authDomain: 'bookloop-c1e49.firebaseapp.com',
    storageBucket: 'bookloop-c1e49.firebasestorage.app',
    measurementId: 'G-W8RSE0TMEL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA6v3U23URhKW3S6KB0WfpA6ulMoxsYfbU',
    appId: '1:1016944723693:android:b9495a9672f51d7ccfaee4',
    messagingSenderId: '1016944723693',
    projectId: 'bookloop-c1e49',
    storageBucket: 'bookloop-c1e49.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAn3xPg-ylZyoPdYCf5TKyPP6VL4neNiWU',
    appId: '1:1016944723693:ios:0df5d8adab300a9fcfaee4',
    messagingSenderId: '1016944723693',
    projectId: 'bookloop-c1e49',
    storageBucket: 'bookloop-c1e49.firebasestorage.app',
    iosClientId: '1016944723693-2p0su8g0ma1mqqipnjoml6labfsj8p5b.apps.googleusercontent.com',
    iosBundleId: 'com.example.bookloop',
  );
}
