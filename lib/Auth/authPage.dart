// ignore_for_file: avoid_print, file_names, use_build_context_synchronously

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stud_notes_tt/Other/blanks.dart';
import '../Home/homePage.dart';
import 'authService.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isResendButtonActive = false;
  int _timerSeconds = 60;
  Timer _timer = Timer(const Duration(seconds: 60), () {});
  late AnimationController animFormShakeController;
  late AnimationController animFormLoginController;
  late AnimationController animTitleLoginController;
  bool verifButton = true;

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
          'assets/Imgs/bg9.jpg',
          fit: BoxFit.cover,
        ),
        // animBackground(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              animTitle(),
              const Spacer(
                flex: 1,
              ),
              Animate(
                autoPlay: false,
                controller: animFormLoginController,
                effects: [
                  MoveEffect(
                      end: const Offset(0, 500),
                      curve: Curves.easeInCubic,
                      duration: 0.75.seconds),
                  ScaleEffect(
                      end: const Offset(0, 0),
                      curve: Curves.easeInCubic,
                      duration: 0.75.seconds)
                ],
                child: Animate(
                  autoPlay: false,
                  controller: animFormShakeController,
                  effects: [
                    ShakeEffect(
                        duration: 0.5.seconds,
                        rotation: 0.05,
                        hz: 7.5,
                        curve: Curves.elasticOut)
                  ],
                  child: BlurryCard(
                    child: Container(
                      height: 280.0,
                      decoration: BoxDecoration(
                        border: const Border(
                          right: BorderSide(
                              width: 0.5,
                              color: Color.fromARGB(48, 255, 255, 255)),
                          left: BorderSide(
                              width: 0.5,
                              color: Color.fromARGB(48, 255, 255, 255)),
                          top: BorderSide(
                              width: 2,
                              color: Color.fromARGB(48, 255, 255, 255)),
                          bottom: BorderSide(
                              width: 2,
                              color: Color.fromARGB(48, 255, 255, 255)),
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
                                  color: Colors.deepPurpleAccent,
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
                                  elevation: WidgetStatePropertyAll(2),
                                ),
                                onPressed: () => _authenticate(false),
                                child: const Text(
                                  'Вход',
                                  style: TextStyle(
                                      fontSize: 16, fontFamily: 'Tektur'),
                                ),
                              ),
                              ElevatedButton(
                                style: const ButtonStyle(
                                    elevation: WidgetStatePropertyAll(2)),
                                onPressed: () => _authenticate(true),
                                child: const Text(
                                  'Регистрация',
                                  style: TextStyle(
                                      fontSize: 16, fontFamily: 'Tektur'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true))
                      .shimmer(
                        angle: 45,
                        duration: 2.seconds,
                        color: Colors.deepPurple.withOpacity(0.5),
                      )
                      .flip(
                        duration: 2.seconds,
                        begin: -0.01,
                        end: 0.01,
                      )
                      .flipH(duration: 2.seconds, begin: -0.01, end: 0.01),
                ),
              ),
              const SizedBox(height: 16.0),
              IgnorePointer(
                ignoring: !_waitVerif(),
                child: Opacity(
                  opacity: _waitVerif() && verifButton ? 1.0 : 0.0,
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
              const Spacer(
                flex: 1,
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
            return;
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
    animFormShakeController.forward(from: 0.0);

    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color.fromARGB(255, 54, 54, 54),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> navigatorToHomePage() async {
    FocusScope.of(context).unfocus();
    AuthService.startListenStreams();

    setState(() {
      verifButton = false;
    });
    animFormLoginController.forward(from: 0.0);
    animTitleLoginController.forward(from: 0.0).then((_) async {
      await Future.delayed(2.75.seconds);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  // -------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _initStateLogic();
    animFormShakeController = AnimationController(
      vsync: this,
    );
    animFormLoginController = AnimationController(
      vsync: this,
    );
    animTitleLoginController = AnimationController(
      vsync: this,
    );
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
    animFormShakeController.dispose();
    animFormLoginController.dispose();
    animTitleLoginController.dispose();
  }

// -------------------------------------------------------------------------

  Widget animBackground() {
    return Container();
  }

  Widget animTitle() {
    return Animate(
      autoPlay: false,
      controller: animTitleLoginController,
      effects: [
        MoveEffect(
            end: const Offset(0, 250),
            curve: Curves.easeInOut,
            duration: 0.75.seconds),
        ScaleEffect(
            end: const Offset(1.2, 1.2),
            curve: Curves.easeInCubic,
            duration: 0.75.seconds),
      ],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: const Text(
          'StudNotesTT',
          style: TextStyle(fontSize: 42, fontFamily: 'Comfortaa'),
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .shimmer(
              angle: 45,
              duration: 2.seconds,
              color: Colors.deepPurple,
            )
            .boxShadow(
              duration: 2.seconds,
              begin: BoxShadow(
                color: Colors.blue.withOpacity(0),
                blurRadius: 10,
              ),
              end: BoxShadow(
                color: Colors.deepPurpleAccent.withOpacity(1),
                blurRadius: 25,
              ),
            ),
      ),
    );
  }
}
