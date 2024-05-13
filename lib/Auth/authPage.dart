// ignore_for_file: avoid_print, file_names

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stud_notes_tt/DB/timetableDB.dart';
import '../DB/prepodsDB.dart';
import '../DB/subjectDB.dart';
import '../Home/homePage.dart';
import 'authService.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isResendButtonActive = false;
  int _timerSeconds = 60;
  Timer _timer = Timer(const Duration(seconds: 60), () {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Center(
        child: Text(
          'Авторизация',
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/Imgs/bg3.jpg',
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 280.0,
                decoration: BoxDecoration(
                  border: const Border(
                    right: BorderSide(
                        width: 0.5, color: Color.fromARGB(48, 255, 255, 255)),
                    left: BorderSide(
                        width: 0.5, color: Color.fromARGB(48, 255, 255, 255)),
                    top: BorderSide(
                        width: 2, color: Color.fromARGB(48, 255, 255, 255)),
                    bottom: BorderSide(
                        width: 2, color: Color.fromARGB(48, 255, 255, 255)),
                  ),
                  color: const Color.fromARGB(75, 0, 0, 0),
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Эл. почта',
                        prefixIcon: Icon(Icons.email),
                      ),
                      onSubmitted: (value) {
                        _authenticate(false);
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Пароль',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        prefixIcon: const Icon(Icons.lock),
                      ),
                      onSubmitted: (value) {
                        _authenticate(false);
                      },
                      obscureText: !_isPasswordVisible,
                    ),
                    const SizedBox(height: 32.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: const ButtonStyle(
                            elevation: MaterialStatePropertyAll(2),
                          ),
                          onPressed: () => _authenticate(false),
                          child: const Text(
                            'Вход',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ElevatedButton(
                          style: const ButtonStyle(
                              elevation: MaterialStatePropertyAll(2)),
                          onPressed: () => _authenticate(true),
                          child: const Text(
                            'Регистрация',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              IgnorePointer(
                ignoring: !_waitVerif(),
                child: Opacity(
                  opacity: _waitVerif() ? 1.0 : 0.0,
                  child: ElevatedButton(
                    onPressed:
                        _isResendButtonActive ? _resendVerificationEmail : null,
                    child: Text(
                      _timerSeconds == 60
                          ? 'Отправить письмо повторно'
                          : 'Отправить письмо повторно ($_timerSeconds сек)',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------------------

  Future<void> _authenticate(bool isRegistration) async {
    try {
      String email = _emailController.text.trim();
      String password = _passwordController.text;
      String? errorMessage;

      FirebaseAuth.instance.currentUser?.reload();

      if (email.isEmpty || password.isEmpty) {
        errorMessage = 'Заполните все поля';
      } else {
        if (isRegistration) {
          errorMessage =
              await AuthService.registerWithEmailAndPassword(email, password);
          if (errorMessage == null) {
            _startTimer();
            _isResendButtonActive = false;
            await _showToastAndNavigateToHomePage();
          }
        } else {
          errorMessage =
              await AuthService.signInWithEmailAndPassword(email, password);
          if (errorMessage == null &&
              FirebaseAuth.instance.currentUser!.emailVerified == true) {
            navigatorToHomePage();
          } else if (errorMessage == null &&
              FirebaseAuth.instance.currentUser!.emailVerified == false) {
            _showToast(
                'На почту пришло письмо с подтверждением. Подтвердите и повторите вход');
          }
        }
      }

      if (errorMessage != null) {
        _showToast(errorMessage);
      }
    } catch (e) {
      print('Ошибка: $e');
      _showToast('Ошибка: $e');
    }
  }

  Future<void> _showToastAndNavigateToHomePage() async {
    _showToast(
      'На почту пришло письмо с подтверждением. Подтвердите и повторите вход',
    );

    await for (bool isEmailVerified
        in AuthService.startEmailVerificationListener(true)) {
      if (isEmailVerified) {
        navigatorToHomePage();
        break;
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timerSeconds > 0) {
            _timerSeconds--;
          } else {
            _timer.cancel();
            _isResendButtonActive = true;
            _timerSeconds = 60;
          }
        });
      } else {
        _timer.cancel();
      }
    });
  }

  bool _waitVerif() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null && !user.emailVerified;
  }

  void _resendVerificationEmail() {
    AuthService.sendEmailVeref();
    _startTimer();
    _isResendButtonActive = false;
  }

  void _showToast(String message) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void navigatorToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
    PrepodDB.listenToPrepodsStream();
    SubjectDB.listenToSubjectsStream();
    TimetableDB.listenToTimetableStream();
  }

  // -------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _initStateLogic();
  }

  Future<void> _initStateLogic() async {
    if (_waitVerif()) {
      _isResendButtonActive = true;
      await _showToastAndNavigateToHomePage();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    AuthService.startEmailVerificationListener(true);
  }
}
