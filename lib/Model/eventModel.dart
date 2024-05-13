// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';

class Event {
  final String name;
  final String category;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String place;
  final String description;

  Event({
    required this.name,
    required this.category,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.place,
    required this.description,
  });
}

List<String> eventCategorys = [
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

Map<DateTime, List<Event>> groupEventByDate(List<Event> eventList) {
  Map<DateTime, List<Event>> groupedEvent = {};
  for (var event in eventList) {
    DateTime date = DateTime(event.date.year, event.date.month, event.date.day);
    if (groupedEvent.containsKey(date)) {
      groupedEvent[date]!.add(event);
    } else {
      groupedEvent[date] = [event];
    }
  }
  return groupedEvent;
}

bool isTimeConflictingRange_Event(TimeOfDay startTime, TimeOfDay endTime) {
  return startTime.hour > endTime.hour ||
      (startTime.hour == endTime.hour && startTime.minute >= endTime.minute);
}

bool isTimeConflictingIntersects_Event(
    DateTime date,
    TimeOfDay startTimeNew,
    TimeOfDay endTimeNew,
    TimeOfDay? startTimeOld,
    TimeOfDay? endTimeOld,
    List<Event> eventList) {
  for (Event event in eventList) {
    if (!isSameDate(event.date, date)) {
      continue;
    }
    if (startTimeOld == event.startTime && endTimeOld == event.endTime) {
      continue;
    }
    if ((startTimeNew.hour < event.endTime.hour ||
            (startTimeNew.hour == event.endTime.hour &&
                startTimeNew.minute <= event.endTime.minute)) &&
        (endTimeNew.hour > event.startTime.hour ||
            (endTimeNew.hour == event.startTime.hour &&
                endTimeNew.minute >= event.startTime.minute))) {
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
