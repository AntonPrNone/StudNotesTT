// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:stud_notes_tt/Auth/authPage.dart';
import 'Home/homePage.dart';
import 'firebase_options.dart';

void main() async {
  await initializeDateFormatting('ru', null);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (FirebaseAuth.instance.currentUser != null) {
    FirebaseAuth.instance.currentUser!.reload();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('assets/Imgs/bg2.jpg'), context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudNotesTT',
      theme: _buildCustomTheme(context),
      home: (FirebaseAuth.instance.currentUser == null ||
              !FirebaseAuth.instance.currentUser!.emailVerified)
          ? AuthPage()
          : HomePage(),
    );
  }

  ThemeData _buildCustomTheme(BuildContext context) {
    return ThemeData.dark().copyWith(
      colorScheme: ColorScheme.dark(
        primary: Color(0xffbb86fc),
        onPrimary: Colors.white,
        onSurface: Colors.white,
      ),
      appBarTheme: AppBarTheme.of(context).copyWith(
        titleTextStyle: TextStyle(fontFamily: 'Tektur', fontSize: 20),
        backgroundColor: const Color.fromARGB(255, 24, 24, 24),
      ),
    );
  }
}
