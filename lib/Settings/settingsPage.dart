// ignore_for_file: use_key_in_widget_constructors, file_names

import 'package:flutter/material.dart';
import 'package:stud_notes_tt/Settings/ItemAcademDataPage.dart';
import 'package:stud_notes_tt/Settings/ItemMenuPage.dart';
import 'package:stud_notes_tt/Settings/ItemAboutSoftPage.dart';
import 'package:stud_notes_tt/devPage.dart';
import '../customSplashFactoryClass.dart';

// Класс для представления пункта настроек
class SettingItem {
  final String title;
  final IconData icon;
  final Widget page; // Страница, на которую будет осуществляться переход

  SettingItem({required this.title, required this.icon, required this.page});
}

class SettingsPage extends StatelessWidget {
  // Список пунктов настроек
  final List<SettingItem> settings = [
    SettingItem(
        title: 'Общие настройки', icon: Icons.settings, page: DevPage()),
    SettingItem(
        title: 'Академические данные',
        icon: Icons.school,
        page: ItemAcademData()),
    SettingItem(title: 'Меню', icon: Icons.menu, page: ItemMenuPage()),
    SettingItem(title: 'Раcписание', icon: Icons.schedule, page: DevPage()),
    SettingItem(title: 'Дисциплины', icon: Icons.menu_book, page: DevPage()),
    SettingItem(title: 'Преподаватели', icon: Icons.group, page: DevPage()),
    SettingItem(
        title: 'О приложении', icon: Icons.info_outline, page: ItemAboutSoft()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
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
          ListView(
            children: [
              const SizedBox(height: 10.0), // Отступ сверху
              // Создаем кнопки для каждого пункта настроек
              for (var setting in settings) ...[
                _buildSettingItem(context, setting),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, SettingItem setting) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 6,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(16.0),
          child: InkWell(
            onTap: () {
              // Переходим на целевую страницу при нажатии на кнопку
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => setting.page),
              );
            },
            splashFactory:
                CustomSplashFactory(), // Используем нашу собственную фабрику
            splashColor: Colors.blue.withOpacity(0.3), // Цвет сплеша
            borderRadius: BorderRadius.circular(16.0),
            child: Ink(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.4),
                borderRadius: BorderRadius.circular(16.0),
                border:
                    Border.all(color: Colors.blue, width: 1.5), // Голубая рамка
              ),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(setting.icon, color: Colors.blue),
                  const SizedBox(width: 16.0),
                  Text(
                    setting.title,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 2,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Пример страницы для настройки 1
class Setting1Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройка 1'),
      ),
      body: const Center(
        child: Text('Это страница настройки 1'),
      ),
    );
  }
}

// Пример страницы для настройки 2
class Setting2Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройка 2'),
      ),
      body: const Center(
        child: Text('Это страница настройки 2'),
      ),
    );
  }
}

// Пример страницы для настройки 3
class Setting3Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройка 3'),
      ),
      body: const Center(
        child: Text('Это страница настройки 3'),
      ),
    );
  }
}
