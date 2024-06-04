// ignore_for_file: file_names, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stud_notes_tt/LocalBD/localSettingsService.dart';
import 'package:tuple/tuple.dart';

class SettingsModel {
  static List<String> orderPreviewMenu = [];
  static bool menuTransparency = false;
  static DateTime endSchoolYear = DateTime(DateTime.now().year, 7, 1);
  static List<Tuple2<String, int>> dayOfWeekRu = [
    const Tuple2("Понедельник", 1),
    const Tuple2("Вторник", 2),
    const Tuple2("Среда", 3),
    const Tuple2("Четверг", 4),
    const Tuple2("Пятница", 5),
    const Tuple2("Суббота", 6),
    const Tuple2("Воскресенье", 7),
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
  static bool showDialogInTimetableAddTeacher = true;
  static bool showDialogInTimetableAddSubject = true;
  static bool showDialogAddInSubjectTeacher = true;
  static bool dialogOpacity = true;
  static bool maxLines1NotePrepod = false;
  static bool autoDeleteExpiredHomework = false;
  static bool autoDeleteExpiredExam = false;
  static bool autoDeleteExpiredEvent = false;
  static bool formatCalendarMonth = true;
  static bool showPercentageStats = false;
  static bool showCheckEmailProfile = false;

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static String? get userId => FirebaseAuth.instance.currentUser?.uid;
  static String get userPath => 'Users/$userId/Settings';
  static DocumentReference get userProfileDoc => _firestore.doc(userPath);

  static Future<String> saveSettings() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        CollectionReference userCollection = _firestore.collection('Users');
        DocumentReference userDoc = userCollection.doc(userId);
        DocumentReference settingsDoc =
            userDoc.collection('Settings').doc('userSettings');
        DocumentSnapshot doc = await settingsDoc.get();
        if (doc.exists) {
          await settingsDoc.update({
            'orderPreviewMenu': orderPreviewMenu,
            'menuTransparency': menuTransparency,
            'endSchoolYear': endSchoolYear.toIso8601String(),
            'dayOfWeekRu': dayOfWeekRu
                .map((item) => {'day': item.item1, 'index': item.item2})
                .toList(),
            'timetableItemTimeList': timetableItemTimeList
                .map((item) => {
                      'startTime':
                          '${item.startTime.hour}:${item.startTime.minute}',
                      'endTime': '${item.endTime.hour}:${item.endTime.minute}',
                    })
                .toList(),
            'showDialogInTimetableAddTeacher': showDialogInTimetableAddTeacher,
            'showDialogInTimetableAddSubject': showDialogInTimetableAddSubject,
            'showDialogAddInSubjectTeacher': showDialogAddInSubjectTeacher,
            'dialogOpacity': dialogOpacity,
            'maxLines1NotePrepod': maxLines1NotePrepod,
            'autoDeleteExpiredHomework': autoDeleteExpiredHomework,
            'autoDeleteExpiredExam': autoDeleteExpiredExam,
            'autoDeleteExpiredEvent': autoDeleteExpiredEvent,
            'formatCalendarMonth': formatCalendarMonth,
            'showPercentageStats': showPercentageStats,
            'showCheckEmailProfile': showCheckEmailProfile,
          });
          return 'Настройки успешно сохранены';
        } else {
          await settingsDoc.set({
            'orderPreviewMenu': orderPreviewMenu,
            'menuTransparency': menuTransparency,
            'endSchoolYear': endSchoolYear.toIso8601String(),
            'dayOfWeekRu': dayOfWeekRu
                .map((item) => {'day': item.item1, 'index': item.item2})
                .toList(),
            'timetableItemTimeList': timetableItemTimeList
                .map((item) => {
                      'startTime':
                          '${item.startTime.hour}:${item.startTime.minute}',
                      'endTime': '${item.endTime.hour}:${item.endTime.minute}',
                    })
                .toList(),
            'showDialogInTimetableAddTeacher': showDialogInTimetableAddTeacher,
            'showDialogInTimetableAddSubject': showDialogInTimetableAddSubject,
            'showDialogAddInSubjectTeacher': showDialogAddInSubjectTeacher,
            'dialogOpacity': dialogOpacity,
            'maxLines1NotePrepod': maxLines1NotePrepod,
            'autoDeleteExpiredHomework': autoDeleteExpiredHomework,
            'autoDeleteExpiredExam': autoDeleteExpiredExam,
            'autoDeleteExpiredEvent': autoDeleteExpiredEvent,
            'formatCalendarMonth': formatCalendarMonth,
            'showPercentageStats': showPercentageStats,
            'showCheckEmailProfile': showCheckEmailProfile,
          });
          return "Документ с настройками успешно создан";
        }
      } else {
        return "Несанкционированный доступ";
      }
    } catch (e) {
      return "Неудачное сохранение настроек: $e";
    }
  }

  static Future<String> loadSettings() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        CollectionReference userCollection = _firestore.collection('Users');
        DocumentReference userDoc = userCollection.doc(userId);
        DocumentReference settingsDoc =
            userDoc.collection('Settings').doc('userSettings');
        DocumentSnapshot doc = await settingsDoc.get();
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          orderPreviewMenu = List<String>.from(data['orderPreviewMenu']);
          menuTransparency = data['menuTransparency'];
          endSchoolYear = DateTime.parse(data['endSchoolYear']);
          dayOfWeekRu = (data['dayOfWeekRu'] as List)
              .map((item) => Tuple2<String, int>(
                  item['day'] as String, item['index'] as int))
              .toList();
          timetableItemTimeList =
              (data['timetableItemTimeList'] as List).map((item) {
            List<String> startTimeParts =
                (item['startTime'] as String).split(':');
            List<String> endTimeParts = (item['endTime'] as String).split(':');
            return TimetableItemTime(
              startTime: TimeOfDay(
                  hour: int.parse(startTimeParts[0]),
                  minute: int.parse(startTimeParts[1])),
              endTime: TimeOfDay(
                  hour: int.parse(endTimeParts[0]),
                  minute: int.parse(endTimeParts[1])),
            );
          }).toList();
          showDialogInTimetableAddTeacher =
              data['showDialogInTimetableAddTeacher'];
          showDialogInTimetableAddSubject =
              data['showDialogInTimetableAddSubject'];
          showDialogAddInSubjectTeacher = data['showDialogAddInSubjectTeacher'];
          dialogOpacity = data['dialogOpacity'];
          maxLines1NotePrepod = data['maxLines1NotePrepod'];
          autoDeleteExpiredHomework = data['autoDeleteExpiredHomework'];
          autoDeleteExpiredExam = data['autoDeleteExpiredExam'];
          autoDeleteExpiredEvent = data['autoDeleteExpiredEvent'];
          formatCalendarMonth = data['formatCalendarMonth'];
          showPercentageStats = data['showPercentageStats'];
          showCheckEmailProfile = data['showCheckEmailProfile'];

          LocalSettingsService.saveSettings();
          return "Настройки успешно восстановлены";
        } else {
          return "Настройки не были ранее сохранены";
        }
      } else {
        return "Несанкционированный доступ";
      }
    } catch (e) {
      return "Неудачное восстановление настроек: $e";
    }
  }
}

class TimetableItemTime {
  TimeOfDay startTime;
  TimeOfDay endTime;

  TimetableItemTime({required this.startTime, required this.endTime});
}

bool isTimeConflictingIntersects_TimetableItemTime(
    TimetableItemTime timetableItemTimeNew,
    [TimetableItemTime? timetableItemTimeOld]) {
  // Перебираем все временные интервалы из списка
  for (TimetableItemTime item in SettingsModel.timetableItemTimeList) {
    // Исключаем из рассмотрения timetableItemTimeNew и timetableItemTimeOld
    if (item != timetableItemTimeNew &&
        (item != timetableItemTimeOld || timetableItemTimeOld == null)) {
      // Проверяем, есть ли пересечение временных интервалов
      if ((item.startTime.hour < timetableItemTimeNew.endTime.hour ||
              (item.startTime.hour == timetableItemTimeNew.endTime.hour &&
                  item.startTime.minute <=
                      timetableItemTimeNew.endTime.minute)) &&
          (item.endTime.hour > timetableItemTimeNew.startTime.hour ||
              (item.endTime.hour == timetableItemTimeNew.startTime.hour &&
                  item.endTime.minute >=
                      timetableItemTimeNew.startTime.minute))) {
        // Если есть пересечение, возвращаем true
        return true;
      }
    }
  }
  // Если нет пересечений, возвращаем false
  return false;
}

bool isTimeConflictingRange_TimetableItemTime(
    TimetableItemTime timetableItemTime) {
  return (timetableItemTime.startTime.hour > timetableItemTime.endTime.hour ||
      (timetableItemTime.startTime.hour == timetableItemTime.endTime.hour &&
          timetableItemTime.startTime.minute >=
              timetableItemTime.endTime.minute));
}
