import 'package:bequeen/utils/session_handler.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

void main() async {
  await Hive.initFlutter();
  await Hive.openBox("queensPlaceTecBoks");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // name: 'bequeenhn',
      options: FirebaseOptions(
          apiKey: "AIzaSyCxewkIKqxuDf13fKk7C7ggMu0ktcJpAJQ",
          authDomain: "bequeenhn.firebaseapp.com",
          projectId: "bequeenhn",
          storageBucket: "bequeenhn.appspot.com",
          messagingSenderId: "224006562546",
          appId: (kIsWeb)
              ? "1:224006562546:web:b7623837ae95a4b49b266b"
              : (defaultTargetPlatform == TargetPlatform.iOS)
                  ? '1:224006562546:ios:e31cd451788919a59b266b'
                  : '1:224006562546:android:24ae0cafed4d39fd9b266b',
          measurementId: "G-WY76G43GFV"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Queen's Place",
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [const Locale('es')],
        theme: ThemeData(primarySwatch: Colors.blue),
        home: SessionHandler());
  }
}
