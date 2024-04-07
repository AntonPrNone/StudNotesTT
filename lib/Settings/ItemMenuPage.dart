// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:stud_notes_tt/LocalBD/localSettingsService.dart';
import '../Model/settingsModel.dart';

class ItemMenuPage extends StatefulWidget {
  @override
  State<ItemMenuPage> createState() => _ItemMenuPageState();
}

class _ItemMenuPageState extends State<ItemMenuPage> {
  bool _menuTransparency = SettingsModel.menuTransparency;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Меню'),
      ),
      body: Stack(
        children: [
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
                _customizationBlock(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _customizationBlock() {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(10),
      dashPattern: [10, 10],
      color: Colors.white.withOpacity(0.25),
      strokeWidth: 2,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
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
            SizedBox(
              height: 15,
            ),
            _customizationListItem('Непрозрачность 100%', false),
            _customizationListItem('Непрозрачность 50%', true),
          ],
        ),
      ),
    );
  }

  Widget _customizationListItem(String title, bool value) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: _menuTransparency,
          onChanged: (newValue) {
            setState(() {
              _menuTransparency = newValue as bool;
              SettingsModel.menuTransparency = _menuTransparency;
            });
            LocalSettingsService.saveMenuTransparency();
          },
          activeColor: Colors.purpleAccent,
        ),
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}
