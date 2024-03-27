// ignore_for_file: file_names

import 'package:flutter/material.dart';

const List<String> dayOfWeekRu = [
  "Понедельник",
  "Вторник",
  "Среда",
  "Четверг",
  "Пятница",
  "Суббота",
];

class TimetableItem {
  final String dayOfWeek;
  final String subjectName;
  final String iconPath;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String room;
  final String teacher;
  final String note;

  TimetableItem({
    required this.dayOfWeek,
    required this.subjectName,
    required this.iconPath,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.teacher,
    required this.note,
  });
}
