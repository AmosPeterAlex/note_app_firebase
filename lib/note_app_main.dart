import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note_app_test/home_page.dart';

///Note App built using Firebase
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyB8tz45w1Lp_Wed8UnytYEZ76qUNHL6K2Y',
          appId: "1:674213172466:android:33fc9c650f8864c228ec6b",
          messagingSenderId: '',
          projectId: 'fir-studyamos',
          storageBucket: 'fir-studyamos.appspot.com'));
  runApp(MyNote(),
  );
}

class MyNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: NoteHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

