import 'package:flutter/material.dart';

class Predmeti extends StatefulWidget {
  const Predmeti({super.key});

  @override
  State<Predmeti> createState() => _PredmetiState();
}

class _PredmetiState extends State<Predmeti> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('data'),
      ),
    );
  }
}
