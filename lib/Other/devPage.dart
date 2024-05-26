// ignore_for_file: file_names

import 'package:flutter/material.dart';

class DevPage extends StatefulWidget {
  const DevPage({super.key});

  @override
  State<DevPage> createState() => _DevPageState();
}

class _DevPageState extends State<DevPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('В разработке'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/Imgs/bg1.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            color: const Color.fromARGB(122, 0, 0, 0),
          ),
          const Center(
            child: Text(
              'В разработке',
              style: TextStyle(fontFamily: 'Comfortaa', fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
