// ignore_for_file: camel_case_types, file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:stud_notes_tt/OtherPage/Calendar/calendarPage.dart';
import 'package:stud_notes_tt/OtherPage/Event/eventPage.dart';
import 'package:stud_notes_tt/OtherPage/Exam/ExamPage.dart';
import 'package:stud_notes_tt/OtherPage/Homework/homeworkPage.dart';
import 'package:stud_notes_tt/OtherPage/Stats/statsPage.dart';
import 'package:stud_notes_tt/OtherPage/Subject/subjectPage.dart';
import 'package:stud_notes_tt/OtherPage/Timer/timerPage.dart';
import 'package:stud_notes_tt/OtherPage/Timetable/timetablePage.dart';
import '../Model/iconDataModel.dart';
import '../Model/secondContainerDataModel.dart';
import '../Model/settingsModel.dart';
import '../OtherPage/Prepods/prepodsPage.dart';

class homePageElementsClass {
  static List<IconDataModel> iconDataList = [
    IconDataModel(
        icon: Icons.schedule_rounded,
        label: 'Расписание',
        page: TimetablePage()),
    IconDataModel(
        icon: Icons.menu_book_rounded,
        label: 'Дисциплины',
        page: SubjectPage()),
    IconDataModel(
        icon: Icons.group_rounded, label: 'Преподаватели', page: PrepodsPage()),
    IconDataModel(
        icon: Icons.assignment_rounded, label: 'Д/З', page: HomeworkPage()),
    IconDataModel(
        icon: Icons.school_rounded, label: 'Экзамены', page: ExamPage()),
    IconDataModel(
        icon: Icons.event_rounded, label: 'События', page: EventPage()),
    IconDataModel(
        icon: Icons.calendar_month_rounded,
        label: 'Календарь',
        page: CalendarPage()),
    IconDataModel(
        icon: Icons.timer_outlined, label: 'Время до', page: TimerPage()),
    IconDataModel(
        icon: Icons.bar_chart_rounded, label: 'Статистика', page: StatsPage()),
  ];

  static List<SecondContainerDataModel> secondContainerDataList = [
    SecondContainerDataModel(
      icon: Icons.schedule_rounded,
      title: 'Расписание занятий',
      bottomText: 'Ваши занятия на выбранный день',
      noDataText: 'Нет уроков',
    ),
    SecondContainerDataModel(
      icon: Icons.assignment_rounded,
      title: 'Домашнее задание',
      bottomText: 'Ваши Д/З на выбранный день',
      noDataText: 'Нет домашней работы',
    ),
    SecondContainerDataModel(
      icon: Icons.school_rounded,
      title: 'Экзамены',
      bottomText: 'Ваши экзамены на выбранный день',
      noDataText: 'Нет экзаменов',
    ),
    SecondContainerDataModel(
      icon: Icons.event_rounded,
      title: 'События',
      bottomText: 'Ваши события на выбранный день',
      noDataText: 'Нет событий',
    ),
  ];

  static void loadSecondContainerData() {
    homePageElementsClass.secondContainerDataList.sort((item1, item2) {
      int index1 = SettingsModel.orderPreviewMenu.indexOf(item1.title);
      int index2 = SettingsModel.orderPreviewMenu.indexOf(item2.title);

      if (index1 == -1) index1 = SettingsModel.orderPreviewMenu.length;
      if (index2 == -1) index2 = SettingsModel.orderPreviewMenu.length;

      return index1.compareTo(index2);
    });
  }
}
