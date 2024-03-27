// ignore_for_file: file_names

import 'package:stud_notes_tt/Model/timetableItemModel.dart';

class TimetableObserver {
  static final TimetableObserver _instance = TimetableObserver._internal();

  factory TimetableObserver() {
    return _instance;
  }

  TimetableObserver._internal();

  final List<void Function(List<TimetableItem>)> _listeners = [];

  void addListener(void Function(List<TimetableItem>) listener) {
    _listeners.add(listener);
  }

  void removeListener(void Function(List<TimetableItem>) listener) {
    _listeners.remove(listener);
  }

  void notifyListeners(List<TimetableItem> newData) {
    for (final listener in _listeners) {
      listener(newData);
    }
  }
}
