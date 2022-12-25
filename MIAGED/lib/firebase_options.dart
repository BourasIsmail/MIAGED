import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
///
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
///

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
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
      apiKey: "AIzaSyDhiAHVjiQ21D5apL_eCSm05wES01zU9cU",
      authDomain: "miaged-734a6.firebaseapp.com",
      projectId: "miaged-734a6",
      storageBucket: "miaged-734a6.appspot.com",
      messagingSenderId: "83357900852",
      appId: "1:83357900852:web:7f9456f756245526522a61");

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDhiAHVjiQ21D5apL_eCSm05wES01zU9cU',
    appId: '1:83357900852:android:bf175c3cc943f98c522a61',
    messagingSenderId: '83357900852',
    projectId: 'miaged-734a6',
    storageBucket: "miaged-734a6.appspot.com",
  );
}
