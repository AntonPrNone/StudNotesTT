// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';

class SettingsModel {
  static List<String> orderPreviewMenu = [];
  static bool menuTransparency = false;
  static List<String> dayOfWeekRu = [
    "Понедельник",
    "Вторник",
    "Среда",
    "Четверг",
    "Пятница",
    "Суббота",
  ];
  static List<TimetableItemTime> timetableItemTimeList = [
    TimetableItemTime(
        startTime: const TimeOfDay(hour: 8, minute: 0),
        endTime: const TimeOfDay(hour: 9, minute: 30)),
    TimetableItemTime(
        startTime: const TimeOfDay(hour: 9, minute: 40),
        endTime: const TimeOfDay(hour: 11, minute: 10)),
    TimetableItemTime(
        startTime: const TimeOfDay(hour: 11, minute: 50),
        endTime: const TimeOfDay(hour: 13, minute: 20)),
    TimetableItemTime(
        startTime: const TimeOfDay(hour: 13, minute: 40),
        endTime: const TimeOfDay(hour: 15, minute: 10)),
  ];
}

class TimetableItemTime {
  TimeOfDay startTime;
  TimeOfDay endTime;

  TimetableItemTime({required this.startTime, required this.endTime});
}

bool isTimeConflictingIntersects_TimetableItemTime(TimetableItemTime timetableItemTimeNew,
    [TimetableItemTime? timetableItemTimeOld]) {
  // Перебираем все временные интервалы из списка
  for (TimetableItemTime item in SettingsModel.timetableItemTimeList) {
    // Исключаем из рассмотрения timetableItemTimeNew и timetableItemTimeOld
    if (item != timetableItemTimeNew &&
        (item != timetableItemTimeOld || timetableItemTimeOld == null)) {
      // Проверяем, есть ли пересечение временных интервалов
      if ((item.startTime.hour < timetableItemTimeNew.endTime.hour ||
              (item.startTime.hour == timetableItemTimeNew.endTime.hour &&
                  item.startTime.minute <= timetableItemTimeNew.endTime.minute)) &&
          (item.endTime.hour > timetableItemTimeNew.startTime.hour ||
              (item.endTime.hour == timetableItemTimeNew.startTime.hour &&
                  item.endTime.minute >= timetableItemTimeNew.startTime.minute))) {
        // Если есть пересечение, возвращаем true
        return true;
      }
    }
  }
  // Если нет пересечений, возвращаем false
  return false;
}

bool isTimeConflictingRange_TimetableItemTime(TimetableItemTime timetableItemTime) {
  return (timetableItemTime.startTime.hour > timetableItemTime.endTime.hour ||
      (timetableItemTime.startTime.hour == timetableItemTime.endTime.hour &&
          timetableItemTime.startTime.minute >= timetableItemTime.endTime.minute));
}
