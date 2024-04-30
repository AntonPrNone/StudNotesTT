// ignore_for_file: camel_case_types, file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:stud_notes_tt/OtherPage/Homework/homeworkPage.dart';
import 'package:stud_notes_tt/OtherPage/Subject/subjectPage.dart';
import 'package:stud_notes_tt/OtherPage/Timetable/timetablePage.dart';
import 'package:stud_notes_tt/devPage.dart';
import '../Model/iconDataModel.dart';
import '../Model/secondContainerDataModel.dart';
import '../Model/settingsModel.dart';
import '../OtherPage/Prepods/prepodsPage.dart';

class homePageElementsClass {
  static List<IconDataModel> iconDataList = [
    IconDataModel(
        icon: Icons.schedule, label: 'Расписание', page: TimetablePage()),
    IconDataModel(
        icon: Icons.menu_book, label: 'Дисциплины', page: SubjectPage()),
    IconDataModel(
        icon: Icons.group, label: 'Преподаватели', page: PrepodsPage()),
    IconDataModel(icon: Icons.event_busy, label: 'Пропуски', page: DevPage()),
    IconDataModel(icon: Icons.book, label: 'Д/З', page: HomeworkPage()),
    IconDataModel(icon: Icons.note, label: 'Записи', page: DevPage()),
    IconDataModel(icon: Icons.calculate, label: 'Расчёт', page: DevPage()),
    IconDataModel(
        icon: Icons.lightbulb_outline, label: 'Примечания', page: DevPage()),
    IconDataModel(
        icon: Icons.bar_chart_rounded, label: 'Статистика', page: DevPage()),
  ];

  static List<SecondContainerDataModel> secondContainerDataList = [
    SecondContainerDataModel(
      icon: Icons.schedule,
      title: 'Расписание занятий',
      bottomText: 'У Вас нет занятий на сегодня',
      noDataText: 'Нет уроков',
    ),
    SecondContainerDataModel(
      icon: Icons.book_online,
      title: 'Домашнее задание',
      bottomText: 'У Вас нет домашней работы на сегодня',
      noDataText: 'Нет домашней работы',
    ),
    SecondContainerDataModel(
      icon: Icons.note_alt_rounded,
      title: 'Экзамены',
      bottomText: 'У Вас нет экзаменов на сегодня',
      noDataText: 'Нет экзаменов',
    ),
    SecondContainerDataModel(
      icon: Icons.calendar_month,
      title: 'События',
      bottomText: 'У Вас нет событий на сегодня',
      noDataText: 'Нет событий',
    ),
  ];

  static void loadSecondContainerData() {
    // Сортировка списка по полю orderPreviewMenu
    homePageElementsClass.secondContainerDataList.sort((item1, item2) {
      int index1 = SettingsModel.orderPreviewMenu.indexOf(item1.title);
      int index2 = SettingsModel.orderPreviewMenu.indexOf(item2.title);

      // Если элемент не найден в orderPreviewMenu, поместим его в конец списка
      if (index1 == -1) index1 = SettingsModel.orderPreviewMenu.length;
      if (index2 == -1) index2 = SettingsModel.orderPreviewMenu.length;

      return index1.compareTo(index2);
    });
  }
}
