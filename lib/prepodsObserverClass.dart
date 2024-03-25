import 'DB/prepodsDB.dart';

class PrepodsObserver {
  static final PrepodsObserver _instance = PrepodsObserver._internal();

  factory PrepodsObserver() {
    return _instance;
  }

  PrepodsObserver._internal();

  final List<void Function(List<Prepod>)> _listeners = [];

  void addListener(void Function(List<Prepod>) listener) {
    _listeners.add(listener);
  }

  void removeListener(void Function(List<Prepod>) listener) {
    _listeners.remove(listener);
  }

  void notifyListeners(List<Prepod> newData) {
    for (final listener in _listeners) {
      listener(newData);
    }
  }
}
