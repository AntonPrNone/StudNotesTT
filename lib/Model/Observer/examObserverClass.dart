// ignore_for_file: file_names

import 'package:stud_notes_tt/Model/examModel.dart';

class ExamObserver {
  static final ExamObserver _instance = ExamObserver._internal();

  factory ExamObserver() {
    return _instance;
  }

  ExamObserver._internal();

  final List<void Function(List<Exam>)> _listeners = [];

  void addListener(void Function(List<Exam>) listener) {
    _listeners.add(listener);
  }

  void removeListener(void Function(List<Exam>) listener) {
    _listeners.remove(listener);
  }

  void notifyListeners(List<Exam> newData) {
    for (final listener in _listeners) {
      listener(newData);
    }
  }
}
