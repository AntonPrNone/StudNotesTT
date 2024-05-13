// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';

const List<String> dayOfWeekConstRu = [
  "Понедельник",
  "Вторник",
  "Среда",
  "Четверг",
  "Пятница",
  "Суббота",
  "Воскресенье"
];

const List<String> dayOfWeekConstCutRu = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"];

class TimetableItem {
  String dayOfWeek;
  String subjectName;
  String iconPath;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String room;
  String teacher;
  String note;

  TimetableItem({
    this.dayOfWeek = '',
    this.subjectName = '',
    this.iconPath = '',
    this.startTime = const TimeOfDay(hour: 8, minute: 0),
    this.endTime = const TimeOfDay(hour: 9, minute: 30),
    this.room = '',
    this.teacher = '',
    this.note = '',
  });
}



bool isTimeConflictingIntersects_TimetableItem(TimetableItem timetableItemNew,
    TimetableItem timetableItemOld, List<TimetableItem> timetableItemList) {
  for (TimetableItem item in timetableItemList) {
    if (item != timetableItemNew &&
        item != timetableItemOld &&
        item.dayOfWeek == timetableItemNew.dayOfWeek) {
      if ((item.startTime.hour < timetableItemNew.endTime.hour ||
              (item.startTime.hour == timetableItemNew.endTime.hour &&
                  item.startTime.minute <= timetableItemNew.endTime.minute)) &&
          (item.endTime.hour > timetableItemNew.startTime.hour ||
              (item.endTime.hour == timetableItemNew.startTime.hour &&
                  item.endTime.minute >= timetableItemNew.startTime.minute))) {
        return true;
      }
    }
  }
  return false;
}

bool isTimeConflictingRange_TimetableItem(TimetableItem timetableItem) {
  return (timetableItem.startTime.hour > timetableItem.endTime.hour ||
      (timetableItem.startTime.hour == timetableItem.endTime.hour &&
          timetableItem.startTime.minute >= timetableItem.endTime.minute));
}
