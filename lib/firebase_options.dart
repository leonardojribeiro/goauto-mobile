import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB8y0ZDAN_dbwc0yawWuvFkLEBaoLgQOtY',
    appId: '1:6490506431:web:86473312a670ca6df6320a',
    messagingSenderId: '6490506431',
    projectId: 'goauto-92933',
    authDomain: 'goauto-92933.firebaseapp.com',
    storageBucket: 'goauto-92933.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBV7FQ8m4kX7bBk_586Y8qpOlc92LTowC0',
    appId: '1:6490506431:android:c35eed86434f5ebbf6320a',
    messagingSenderId: '6490506431',
    projectId: 'goauto-92933',
    storageBucket: 'goauto-92933.appspot.com',
  );
}
