// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/settingsModel.dart';

class LocalSettingsService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveOrderPreviewMenu(List<String> previewMenu) async {
    await _prefs?.setStringList('orderPreviewMenu', previewMenu);
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
    await _prefs?.setStringList('dayOfWeekRu', SettingsModel.dayOfWeekRu);
  }

  static void getDayOfWeekRu() {
    var dayOfWeekRu = _prefs?.getStringList('dayOfWeekRu');
    if (dayOfWeekRu != null) {
      SettingsModel.dayOfWeekRu = dayOfWeekRu;
    }
  }

  static Future<void> saveTimetableItemTimeList() async {
    List<String> serializedList = SettingsModel.timetableItemTimeList.map((item) {
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
          startTime:
              TimeOfDay(hour: int.parse(startTimeParts[0]), minute: int.parse(startTimeParts[1])),
          endTime: TimeOfDay(hour: int.parse(endTimeParts[0]), minute: int.parse(endTimeParts[1])),
        );
      }).toList();
      SettingsModel.timetableItemTimeList = timetableItemTimeList;
    }
  }
}
