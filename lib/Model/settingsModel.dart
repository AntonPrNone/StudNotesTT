// ignore_for_file: file_names, non_constant_identifier_names

class SettingsModel {
  static List<String> orderPreviewMenu = [];
  static bool _menuTransparency = false;
  static Function(bool)? _menuTransparencyCallback;

  static bool get MenuTransparency => _menuTransparency;

  static setMenuTransparencyCallback(Function(bool) callback) {
    _menuTransparencyCallback = callback;
  }

  static set MenuTransparency(bool value) {
    _menuTransparency = value;
    // После установки нового значения вызываем колбэк
    _menuTransparencyCallback?.call(value);
  }
}
