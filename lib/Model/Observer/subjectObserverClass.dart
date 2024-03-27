// ignore_for_file: file_names

import 'package:stud_notes_tt/Model/subjectModel.dart';

class SubjectObserver {
  static final SubjectObserver _instance = SubjectObserver._internal();

  factory SubjectObserver() {
    return _instance;
  }

  SubjectObserver._internal();

  final List<void Function(List<Subject>)> _listeners = [];

  void addListener(void Function(List<Subject>) listener) {
    _listeners.add(listener);
  }

  void removeListener(void Function(List<Subject>) listener) {
    _listeners.remove(listener);
  }

  void notifyListeners(List<Subject> newData) {
    for (final listener in _listeners) {
      listener(newData);
    }
  }
}
