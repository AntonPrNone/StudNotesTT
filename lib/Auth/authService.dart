// ignore_for_file: file_names
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _fAuth = FirebaseAuth.instance;

  static Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await _fAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseErrorToRussian(e.code);
    }
  }

  static Future<String?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      await _fAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) await user.sendEmailVerification();

      return null;
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseErrorToRussian(e.code);
    }
  }

  static Future<void> checkEmailVerificationAndReload() async {
    User? user = _fAuth.currentUser;

    if (user != null) {
      await user.reload();
      await user.getIdToken(true);
    }
  }

  static Stream<bool> startEmailVerificationListener(bool shouldOpen) async* {
    await for (var _ in Stream.periodic(const Duration(seconds: 1))) {
      if (!shouldOpen) {
        break;
      }

      await checkEmailVerificationAndReload();
      yield _fAuth.currentUser?.emailVerified ?? false;
    }
  }

  static Future<void> sendEmailVeref() async {
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
    } on FirebaseAuthException {
      null;
    }
  }

  static String _mapFirebaseErrorToRussian(String errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        return 'Неверный формат электронной почты';
      case 'invalid-password':
        return 'Неверный формат пароля. Пароль должен содержать не менее 6 символов';
      case 'weak-password':
        return 'Неверный формат пароля. Пароль должен содержать не менее 6 символов';
      case 'user-not-found':
        return 'Пользователь с данной почтой не найден';
      case 'wrong-password':
        return 'Неверный пароль';
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Неверная почта или пароль';
      case 'too-many-requests':
        return 'Слишком много запросов подряд. Пожалуйста, попробуйте позже';
      case 'email-already-in-use':
        return 'Указанный адрес электронной почты уже используется существующим пользователем';
      case 'email-already-exists':
        return 'Указанный адрес электронной почты уже используется существующим пользователем';
      case 'user-disabled':
        return 'Учётная запись отключена';
      case 'internal-error':
        return 'Ошибка сервера. Повторите попытку позже';
      default:
        return 'Не удаётся авторизоваться, проверьте корректность/валидность email/пароля';
    }
  }

  static void signOut() async {
    await _fAuth.signOut();
  }
}
