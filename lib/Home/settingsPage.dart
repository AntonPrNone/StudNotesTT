// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки'),
      ),
      body: ListView(
        children: [
          _buildSettingItem('Настройка 1', Icons.settings),
          _buildSettingDivider(),
          _buildSettingItem('Настройка 2', Icons.accessibility),
          _buildSettingDivider(),
          _buildSettingItem('Настройка 3', Icons.bluetooth),
          // Добавьте другие пункты меню по мере необходимости
        ],
      ),
    );
  }

  Widget _buildSettingItem(String title, IconData icon) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(117, 0, 0, 0), // Цвет фона
        borderRadius: BorderRadius.circular(16.0), // Закругленные углы
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 16.0),
          Text(
            title,
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingDivider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(
        color: Colors.blueAccent, // Цвет черточек
        thickness: 2.0, // Толщина черточек
      ),
    );
  }
}
