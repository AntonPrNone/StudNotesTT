// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static String? get userId => FirebaseAuth.instance.currentUser?.uid;
  static String get userSettingsPath => 'Users/$userId/Settings';

  // Метод для сохранения настроек пользователя
  static Future<void> saveUserSetting(String key, dynamic value) async {
    try {
      final userSettings = {_getFieldName(key): value};
      await _firestore
          .doc(userSettingsPath)
          .set(userSettings, SetOptions(merge: true));
    } catch (e) {
      print('Ошибка сохранения настроек пользователя: $e');
    }
  }

  // Метод для получения настройки пользователя
  static Future<dynamic> getUserSetting(String key) async {
    try {
      final userSettings = await _firestore.doc(userSettingsPath).get();
      final data = userSettings.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey(_getFieldName(key))) {
        return data[_getFieldName(key)];
      } else {
        return null;
      }
    } catch (e) {
      print('Ошибка получения настройки пользователя: $e');
      return null;
    }
  }

  // Приватный метод для преобразования имени поля в формат Firestore
  static String _getFieldName(String key) {
    return 'field_$key';
  }
}
