// ignore_for_file: use_key_in_widget_constructors, file_names, prefer_const_constructors

import 'package:flutter/material.dart';

class DisciplinesPage extends StatefulWidget {
  @override
  State<DisciplinesPage> createState() => _DisciplinesPageState();
}

class _DisciplinesPageState extends State<DisciplinesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Дисциплины'),
      ),
      body: Center(
        child: Text(
          'В разработке',
          style: TextStyle(fontSize: 18, fontFamily: 'Comfortaa'),
        ),
      ),
    );
  }
}
