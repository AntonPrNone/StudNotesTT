// ignore_for_file: file_names

import 'package:stud_notes_tt/Model/userProfileModel.dart';

class UserProfileObserver {
  static final UserProfileObserver _instance = UserProfileObserver._internal();

  factory UserProfileObserver() {
    return _instance;
  }

  UserProfileObserver._internal();

  final List<void Function(UserProfile?)> _listeners = [];

  void addListener(void Function(UserProfile?) listener) {
    _listeners.add(listener);
  }

  void removeListener(void Function(UserProfile?) listener) {
    _listeners.remove(listener);
  }

  void notifyListeners(UserProfile? newData) {
    for (final listener in _listeners) {
      listener(newData);
    }
  }
}
