import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions have not been configured for this platform - '
      'ensure google-services.json is present for Android.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCQfC3HYjSpkwwqpnpLd8KYlolHAsufrHE',
    authDomain: 'projeto-gps-cashly.firebaseapp.com',
    projectId: 'projeto-gps-cashly',
    storageBucket: 'projeto-gps-cashly.firebasestorage.app',
    messagingSenderId: '255720101962',
    appId: '1:255720101962:web:32886a4bd2de6eefef2eb3',
    measurementId: 'G-11JH6JZH8M',
  );
}
