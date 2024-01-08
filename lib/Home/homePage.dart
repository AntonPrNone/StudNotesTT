// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stud_notes_tt/Auth/authPage.dart';
import 'package:stud_notes_tt/Auth/authService.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Меню'),
        actions: [
          IconButton(
              onPressed: () {
                AuthService.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AuthPage()),
                );
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ))
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  '${FirebaseAuth.instance.currentUser!.email}  верификация: ${FirebaseAuth.instance.currentUser!.emailVerified}'),
              SizedBox(
                height: 15,
              ),
              Text(
                'Поздравляю с выходом версии приложения',
                style: TextStyle(
                    fontFamily: 'Comfortaa', color: Color(0xffbb86fc)),
              ),
              Text(
                '0.012',
                style: TextStyle(
                    fontFamily: 'Comfortaa', color: Colors.red, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
