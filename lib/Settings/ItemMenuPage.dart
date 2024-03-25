// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '../Model/settingsModel.dart';

class ItemMenuPage extends StatefulWidget {
  @override
  State<ItemMenuPage> createState() => _ItemMenuPageState();
}

class _ItemMenuPageState extends State<ItemMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Меню'),
      ),
      body: Stack(
        children: [
          // Фоновое изображение
          Image.asset(
            'assets/Imgs/bg1.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color: const Color.fromARGB(122, 0, 0, 0),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                customizationBlock(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget customizationBlock() {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(10),
      dashPattern: [10, 10],
      color: Colors.white.withOpacity(0.25),
      strokeWidth: 2,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Персонализация',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.palette,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text(
                'Непрозрачность 100%',
                style: TextStyle(color: Colors.white),
              ),
              leading: Checkbox(
                value: !SettingsModel.MenuTransparency,
                onChanged: (value) {
                  setState(() {
                    SettingsModel.MenuTransparency = !value!;
                  });
                },
                activeColor: Colors.purpleAccent,
                checkColor: Colors.black,
              ),
            ),
            ListTile(
              title: Text(
                'Непрозрачность 50%',
                style: TextStyle(color: Colors.white),
              ),
              leading: Checkbox(
                value: SettingsModel.MenuTransparency,
                onChanged: (value) {
                  setState(() {
                    SettingsModel.MenuTransparency = value!;
                  });
                },
                activeColor: Colors.purpleAccent,
                checkColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
