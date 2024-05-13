// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';

class Exam {
  final String nameSubject;
  final String examCategory;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String room;
  final String description;

  Exam({
    required this.nameSubject,
    required this.examCategory,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.description,
  });
}

List<String> examCategorys = [
  'Экзамен',
  'Квалификационный экзамен',
  'Демонстрационный экзамен',
  'Вступительный экзамен',
  'ГИА',
  'ОГЭ',
  'ЕГЭ',
  'ВПР',
  'Зачёт',
  'Дифференцированный зачёт',
  'Защита диплома',
  'Предзащита диплома',
  'Подготовительный день',
  'Другое'
];

Map<DateTime, List<Exam>> groupExamByDate(List<Exam> examList) {
  Map<DateTime, List<Exam>> groupedExam = {};
  for (var exam in examList) {
    DateTime date = DateTime(exam.date.year, exam.date.month, exam.date.day);
    if (groupedExam.containsKey(date)) {
      groupedExam[date]!.add(exam);
    } else {
      groupedExam[date] = [exam];
    }
  }
  return groupedExam;
}

bool isTimeConflictingRange_Exam(TimeOfDay startTime, TimeOfDay endTime) {
  return startTime.hour > endTime.hour ||
      (startTime.hour == endTime.hour && startTime.minute >= endTime.minute);
}

bool isTimeConflictingIntersects_Exam(
    DateTime date,
    TimeOfDay startTimeNew,
    TimeOfDay endTimeNew,
    TimeOfDay? startTimeOld,
    TimeOfDay? endTimeOld,
    List<Exam> examList) {
  for (Exam exam in examList) {
    if (!isSameDate(exam.date, date)) {
      continue;
    }
    if (startTimeOld == exam.startTime && endTimeOld == exam.endTime) {
      continue;
    }
    if ((startTimeNew.hour < exam.endTime.hour ||
            (startTimeNew.hour == exam.endTime.hour &&
                startTimeNew.minute <= exam.endTime.minute)) &&
        (endTimeNew.hour > exam.startTime.hour ||
            (endTimeNew.hour == exam.startTime.hour &&
                endTimeNew.minute >= exam.startTime.minute))) {
      return true;
    }
  }
  return false;
}

bool isSameDate(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}
