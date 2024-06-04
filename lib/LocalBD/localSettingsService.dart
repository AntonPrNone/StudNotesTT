// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import '../Model/settingsModel.dart';

class LocalSettingsService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static void loadSettings() {
    getOrderPreviewMenu();
    getMenuTransparency();
    getDayOfWeekRu();
    getTimetableItemTimeList();
    getEndSchoolYear();
    getShowDialogInTimetableAddTeacher();
    getShowDialogInTimetableAddSubject();
    getShowDialogAddInSubjectTeacher();
    getDialogOpacity();
    getMaxLines1NotePrepod();
    getAutoDeleteExpiredHomework();
    getAutoDeleteExpiredExam();
    getAutoDeleteExpiredEvent();
    getFormatCalendarMonth();
    getShowPercentageStats();
    getShowCheckEmailProfile();
  }

  static void saveSettings() {
    saveOrderPreviewMenu();
    saveMenuTransparency();
    saveDayOfWeekRu();
    saveTimetableItemTimeList();
    saveEndSchoolYear();
    saveShowDialogInTimetableAddTeacher();
    saveShowDialogInTimetableAddSubject();
    saveShowDialogAddInSubjectTeacher();
    saveDialogOpacity(SettingsModel.dialogOpacity);
    saveMaxLines1NotePrepod();
    saveAutoDeleteExpiredHomework();
    saveAutoDeleteExpiredExam();
    saveAutoDeleteExpiredEvent();
    saveFormatCalendarMonth();
    saveShowPercentageStats();
    saveShowCheckEmailProfile();
  }

  static Future<void> saveOrderPreviewMenu() async {
    await _prefs?.setStringList(
        'orderPreviewMenu', SettingsModel.orderPreviewMenu);
  }

  static void getOrderPreviewMenu() {
    final orderPreviewMenu = _prefs?.getStringList('orderPreviewMenu');
    if (orderPreviewMenu != null) {
      SettingsModel.orderPreviewMenu = orderPreviewMenu;
    }
  }

  static Future<void> saveMenuTransparency() async {
    await _prefs?.setBool('menuTransparency', SettingsModel.menuTransparency);
  }

  static void getMenuTransparency() {
    var menuTransparency = _prefs?.getBool('menuTransparency');
    if (menuTransparency != null) {
      SettingsModel.menuTransparency = menuTransparency;
    }
  }

  static Future<void> saveDayOfWeekRu() async {
    List<String> dayOfWeekRuStrings = SettingsModel.dayOfWeekRu
        .map((tuple) => "${tuple.item1},${tuple.item2}")
        .toList();
    await _prefs?.setStringList('dayOfWeekRu', dayOfWeekRuStrings);
  }

  static void getDayOfWeekRu() {
    var dayOfWeekRuStrings = _prefs?.getStringList('dayOfWeekRu');
    if (dayOfWeekRuStrings != null) {
      SettingsModel.dayOfWeekRu = dayOfWeekRuStrings.map((string) {
        List<String> parts = string.split(',');
        return Tuple2(parts[0], int.parse(parts[1]));
      }).toList();
    }
  }

  static Future<void> saveTimetableItemTimeList() async {
    List<String> serializedList =
        SettingsModel.timetableItemTimeList.map((item) {
      return '${item.startTime.hour}:${item.startTime.minute}-${item.endTime.hour}:${item.endTime.minute}';
    }).toList();
    await _prefs?.setStringList('timetableItemTimeList', serializedList);
  }

  static void getTimetableItemTimeList() {
    final serializedList = _prefs?.getStringList('timetableItemTimeList');
    if (serializedList != null) {
      List<TimetableItemTime> timetableItemTimeList = serializedList.map((str) {
        List<String> parts = str.split('-');
        List<String> startTimeParts = parts[0].split(':');
        List<String> endTimeParts = parts[1].split(':');
        return TimetableItemTime(
          startTime: TimeOfDay(
              hour: int.parse(startTimeParts[0]),
              minute: int.parse(startTimeParts[1])),
          endTime: TimeOfDay(
              hour: int.parse(endTimeParts[0]),
              minute: int.parse(endTimeParts[1])),
        );
      }).toList();
      SettingsModel.timetableItemTimeList = timetableItemTimeList;
    }
  }

  static Future<void> saveEndSchoolYear() async {
    await _prefs?.setInt(
        'endSchoolYear', SettingsModel.endSchoolYear.millisecondsSinceEpoch);
  }

  static void getEndSchoolYear() {
    var endSchoolYearMillis = _prefs?.getInt('endSchoolYear');
    if (endSchoolYearMillis != null) {
      SettingsModel.endSchoolYear =
          DateTime.fromMillisecondsSinceEpoch(endSchoolYearMillis);
    }
  }

  static Future<void> saveShowDialogInTimetableAddTeacher() async {
    await _prefs?.setBool('showDialogInTimetableAddTeacher',
        SettingsModel.showDialogInTimetableAddTeacher);
  }

  static void getShowDialogInTimetableAddTeacher() {
    var showDialogInTimetableAddTeacher =
        _prefs?.getBool('showDialogInTimetableAddTeacher');
    if (showDialogInTimetableAddTeacher != null) {
      SettingsModel.showDialogInTimetableAddTeacher =
          showDialogInTimetableAddTeacher;
    }
  }

  static Future<void> saveShowDialogInTimetableAddSubject() async {
    await _prefs?.setBool('showDialogInTimetableAddSubject',
        SettingsModel.showDialogInTimetableAddSubject);
  }

  static void getShowDialogInTimetableAddSubject() {
    var showDialogInTimetableAddSubject =
        _prefs?.getBool('showDialogInTimetableAddSubject');
    if (showDialogInTimetableAddSubject != null) {
      SettingsModel.showDialogInTimetableAddSubject =
          showDialogInTimetableAddSubject;
    }
  }

  static Future<void> saveShowDialogAddInSubjectTeacher() async {
    await _prefs?.setBool('showDialogAddInSubjectTeacher',
        SettingsModel.showDialogAddInSubjectTeacher);
  }

  static void getShowDialogAddInSubjectTeacher() {
    var showDialogAddInSubjectTeacher =
        _prefs?.getBool('showDialogAddInSubjectTeacher');
    if (showDialogAddInSubjectTeacher != null) {
      SettingsModel.showDialogAddInSubjectTeacher =
          showDialogAddInSubjectTeacher;
    }
  }

  static Future<void> saveDialogOpacity(bool value) async {
    await _prefs?.setBool('dialogOpacity', value);
  }

  static Future<bool> getDialogOpacity() async {
    return _prefs?.getBool('dialogOpacity') ?? SettingsModel.dialogOpacity;
  }

  static Future<void> saveMaxLines1NotePrepod() async {
    await _prefs?.setBool(
        'maxLines1NotePrepod', SettingsModel.maxLines1NotePrepod);
  }

  static void getMaxLines1NotePrepod() {
    var maxLines1NotePrepod = _prefs?.getBool('maxLines1NotePrepod');
    if (maxLines1NotePrepod != null) {
      SettingsModel.maxLines1NotePrepod = maxLines1NotePrepod;
    }
  }

  static Future<void> saveAutoDeleteExpiredHomework() async {
    await _prefs?.setBool(
        'autoDeleteExpiredHomework', SettingsModel.autoDeleteExpiredHomework);
  }

  static void getAutoDeleteExpiredHomework() {
    var autoDeleteExpiredHomework =
        _prefs?.getBool('autoDeleteExpiredHomework');
    if (autoDeleteExpiredHomework != null) {
      SettingsModel.autoDeleteExpiredHomework = autoDeleteExpiredHomework;
    }
  }

  static Future<void> saveAutoDeleteExpiredExam() async {
    await _prefs?.setBool(
        'autoDeleteExpiredExam', SettingsModel.autoDeleteExpiredExam);
  }

  static void getAutoDeleteExpiredExam() {
    var autoDeleteExpiredExam = _prefs?.getBool('autoDeleteExpiredExam');
    if (autoDeleteExpiredExam != null) {
      SettingsModel.autoDeleteExpiredExam = autoDeleteExpiredExam;
    }
  }

  static Future<void> saveAutoDeleteExpiredEvent() async {
    await _prefs?.setBool(
        'autoDeleteExpiredEvent', SettingsModel.autoDeleteExpiredEvent);
  }

  static void getAutoDeleteExpiredEvent() {
    var autoDeleteExpiredEvent = _prefs?.getBool('autoDeleteExpiredEvent');
    if (autoDeleteExpiredEvent != null) {
      SettingsModel.autoDeleteExpiredEvent = autoDeleteExpiredEvent;
    }
  }

  static Future<void> saveFormatCalendarMonth() async {
    await _prefs?.setBool(
        'formatCalendarMonth', SettingsModel.formatCalendarMonth);
  }

  static void getFormatCalendarMonth() {
    var formatCalendarMonth = _prefs?.getBool('formatCalendarMonth');
    if (formatCalendarMonth != null) {
      SettingsModel.formatCalendarMonth = formatCalendarMonth;
    }
  }

  static Future<void> saveShowPercentageStats() async {
    await _prefs?.setBool(
        'showPercentageStats', SettingsModel.showPercentageStats);
  }

  static void getShowPercentageStats() {
    var showPercentageStats = _prefs?.getBool('showPercentageStats');
    if (showPercentageStats != null) {
      SettingsModel.showPercentageStats = showPercentageStats;
    }
  }

  static Future<void> saveShowCheckEmailProfile() async {
    await _prefs?.setBool(
        'showCheckEmailProfile', SettingsModel.showCheckEmailProfile);
  }

  static void getShowCheckEmailProfile() {
    var showCheckEmailProfile = _prefs?.getBool('showCheckEmailProfile');
    if (showCheckEmailProfile != null) {
      SettingsModel.showCheckEmailProfile = showCheckEmailProfile;
    }
  }
}
