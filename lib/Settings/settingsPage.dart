// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stud_notes_tt/Settings/ItemAcademDataPage.dart';
import 'package:stud_notes_tt/Settings/ItemCalendarPage.dart';
import 'package:stud_notes_tt/Settings/ItemEventPage.dart';
import 'package:stud_notes_tt/Settings/ItemExamPage.dart';
import 'package:stud_notes_tt/Settings/ItemGlobalPage.dart';
import 'package:stud_notes_tt/Settings/ItemHomeworkPage.dart';
import 'package:stud_notes_tt/Settings/ItemMenuPage.dart';
import 'package:stud_notes_tt/Settings/ItemAboutSoftPage.dart';
import 'package:stud_notes_tt/Settings/ItemPrepodPage.dart';
import 'package:stud_notes_tt/Settings/ItemProfilePage.dart';
import 'package:stud_notes_tt/Settings/ItemStatsPage.dart';
import 'package:stud_notes_tt/Settings/ItemSubjectPage.dart';
import 'package:stud_notes_tt/Settings/ItemTimerPage.dart';
import 'package:stud_notes_tt/Settings/ItemTimetabePage.dart';
import '../customSplashFactoryClass.dart';

// Класс для представления пункта настроек
class SettingItem {
  final String title;
  final IconData icon;
  final Widget page; // Страница, на которую будет осуществляться переход

  SettingItem({required this.title, required this.icon, required this.page});
}

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final List<SettingItem> settings = [
    SettingItem(
        title: 'Общие настройки',
        icon: Icons.settings,
        page: const ItemGlobalPage()),
    SettingItem(
        title: 'Профиль',
        icon: Icons.account_circle,
        page: const ItemProfilePage()),
    SettingItem(
        title: 'Академические данные',
        icon: Icons.school_rounded,
        page: ItemAcademData()),
    SettingItem(title: 'Меню', icon: Icons.menu_rounded, page: ItemMenuPage()),
    SettingItem(
        title: 'Раcписание',
        icon: Icons.schedule_rounded,
        page: const ItemTimetablePage()),
    SettingItem(
        title: 'Дисциплины',
        icon: Icons.menu_book_rounded,
        page: const ItemSubjectPage()),
    SettingItem(
        title: 'Преподаватели',
        icon: Icons.group_rounded,
        page: const ItemPrepodPage()),
    SettingItem(
        title: 'Д/З',
        icon: Icons.assignment_rounded,
        page: const ItemHomeworkPage()),
    SettingItem(
        title: 'Экзамены',
        icon: Icons.school_rounded,
        page: const ItemExamPage()),
    SettingItem(
        title: 'События',
        icon: Icons.event_rounded,
        page: const ItemEventPage()),
    SettingItem(
        title: 'Календарь',
        icon: Icons.calendar_month_rounded,
        page: const ItemCalendarPage()),
    SettingItem(
        title: 'Статистика',
        icon: Icons.bar_chart_rounded,
        page: const ItemStatsPage()),
    SettingItem(
        title: 'Время до', icon: Icons.timer_outlined, page: ItemTimerPage()),
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
              const SizedBox(height: 10.0),
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
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Material(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16.0),
          child: InkWell(
            onTap: () {
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
