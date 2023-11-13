import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:v1tesis/src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyAlgTpD6pQQx1f4ylu9RUd5CgRfEOpO-vA',
      projectId: 'geolocalizacion-1cda8',
      messagingSenderId: '874526624526',
      appId: '1:874526624526:android:cdd8bdbb51a14a740c655f',
    ),
  );

  runApp(MyApp());
}
