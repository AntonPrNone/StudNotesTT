// ignore_for_file: file_names
import 'package:stud_notes_tt/Model/homeworkModel.dart';

class HomeworkObserver {
  static final HomeworkObserver _instance = HomeworkObserver._internal();

  factory HomeworkObserver() {
    return _instance;
  }

  HomeworkObserver._internal();

  final List<void Function(List<Homework>)> _listeners = [];

  void addListener(void Function(List<Homework>) listener) {
    _listeners.add(listener);
  }

  void removeListener(void Function(List<Homework>) listener) {
    _listeners.remove(listener);
  }

  void notifyListeners(List<Homework> newData) {
    for (final listener in _listeners) {
      listener(newData);
    }
  }
}
