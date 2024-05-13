// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors, non_constant_identifier_names, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemAboutSoft extends StatefulWidget {
  @override
  State<ItemAboutSoft> createState() => _ItemAboutSoftState();
}

class _ItemAboutSoftState extends State<ItemAboutSoft> {
  String UriCode = 'https://github.com/AntonPrNone/StudNotesTT';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('О приложении'),
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
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildTextWithShadow(
                    text: 'Flutter, Dart, Material Design 3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextWithShadow(
                    text: 'Разработчик:',
                    style: TextStyle(
                      color: Colors.tealAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildTextWithShadow(
                    text: 'Ахтямов А. И.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextWithShadow(
                    text: 'Открытый исходный код приложения:',
                    style: TextStyle(
                      color: Colors.pinkAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  QrImageView(
                    data: "https://github.com/AntonPrNone/StudNotesTT",
                    foregroundColor: Colors.white,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                  SizedBox(height: 10),
                  _buildTextWithShadow(
                    text: 'В формате ссылки:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await launchUrl(Uri.parse(UriCode));
                    },
                    child: _buildTextWithShadow(
                      text: UriCode,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue,
                      ),
                    ),
                  ),
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
          Shadow(
            blurRadius: 4,
            color: Colors.black,
            offset: Offset(2, 2),
          ),
        ],
      ),
    );
  }
}
