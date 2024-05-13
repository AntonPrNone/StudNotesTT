// ignore_for_file: file_names

import 'package:stud_notes_tt/Model/eventModel.dart';

class EventObserver {
  static final EventObserver _instance = EventObserver._internal();

  factory EventObserver() {
    return _instance;
  }

  EventObserver._internal();

  final List<void Function(List<Event>)> _listeners = [];

  void addListener(void Function(List<Event>) listener) {
    _listeners.add(listener);
  }

  void removeListener(void Function(List<Event>) listener) {
    _listeners.remove(listener);
  }

  void notifyListeners(List<Event> newData) {
    for (final listener in _listeners) {
      listener(newData);
    }
  }
}
