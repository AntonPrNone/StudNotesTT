// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemAboutSoft extends StatefulWidget {
  const ItemAboutSoft({super.key});

  @override
  State<ItemAboutSoft> createState() => _ItemAboutSoftState();
}

class _ItemAboutSoftState extends State<ItemAboutSoft> {
  String uriCode = 'https://github.com/AntonPrNone/StudNotesTT';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('О приложении'),
      ),
      body: Stack(
        children: [
          // Фоновое изображение
          Image.asset(
            'assets/Imgs/bg1.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color: const Color.fromARGB(122, 0, 0, 0),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildTextWithShadow(
                    text: 'Используемые технологии:',
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      .animate(delay: 0.2.seconds)
                      .moveX(begin: -50, duration: 0.25.seconds)
                      .fadeIn(duration: 0.5.seconds),
                  _buildTextWithShadow(
                    text: 'Flutter, Dart, Firebase, Material Design 3',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )
                      .animate(delay: 0.2.seconds)
                      .moveX(begin: 50, duration: 0.25.seconds)
                      .fadeIn(duration: 0.5.seconds),
                  const SizedBox(height: 20),
                  _buildTextWithShadow(
                    text: 'Разработчик:',
                    style: const TextStyle(
                      color: Colors.tealAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      .animate(delay: 0.2.seconds)
                      .moveX(begin: -50, duration: 0.25.seconds)
                      .fadeIn(duration: 0.5.seconds),
                  _buildTextWithShadow(
                    text: 'Ахтямов А. И.',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )
                      .animate(delay: 0.2.seconds)
                      .moveX(begin: 50, duration: 0.25.seconds)
                      .fadeIn(duration: 0.5.seconds),
                  const SizedBox(height: 20),
                  _buildTextWithShadow(
                    text: 'Открытый исходный код приложения:',
                    style: const TextStyle(
                      color: Colors.pinkAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate(delay: 0.4.seconds).fadeIn(duration: 1.seconds),
                  QrImageView(
                    data: "https://github.com/AntonPrNone/StudNotesTT",
                    foregroundColor: Colors.white,
                    version: QrVersions.auto,
                    size: 200.0,
                  ).animate(delay: 0.4.seconds).fadeIn(duration: 1.seconds),
                  const SizedBox(height: 10),
                  _buildTextWithShadow(
                    text: 'В формате ссылки:',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      .animate(delay: 0.2.seconds)
                      .moveY(begin: 50, duration: 0.25.seconds)
                      .fadeIn(duration: 0.5.seconds),
                  GestureDetector(
                    onTap: () async {
                      await launchUrl(Uri.parse(uriCode));
                    },
                    child: _buildTextWithShadow(
                      text: uriCode,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue,
                      ),
                    ),
                  )
                      .animate(delay: 0.2.seconds)
                      .moveY(begin: 50, duration: 0.25.seconds)
                      .fadeIn(duration: 0.5.seconds),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextWithShadow({
    required String text,
    required TextStyle style,
  }) {
    return Text(
      text,
      style: style.copyWith(
        shadows: [
          const Shadow(
            blurRadius: 4,
            color: Colors.black,
            offset: Offset(2, 2),
          ),
        ],
      ),
    );
  }
}
