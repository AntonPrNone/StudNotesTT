// ignore_for_file: use_build_context_synchronously, avoid_print, file_names

import 'package:flutter/material.dart';
import 'dart:async';
import 'customIconsClass.dart';

class ImageSettings {
  static Future<void> precacheImages(BuildContext context) async {
    final List<String> imagePaths = [
      'assets/Imgs/bg1.jpg',
      'assets/Imgs/bg2.jpg',
      'assets/Imgs/bg4.jpg',
      'assets/Icons/User.png',
      'assets/Imgs/bgEmpty.png',
      'assets/Imgs/bg3.jpg',
    ];

    for (var imagePath in imagePaths) {
      await precacheImage(AssetImage(imagePath), context);
    }

    for (var imagePath in CustomIcons.subjectIconPaths.values) {
      await precacheImage(AssetImage(imagePath), context);
    }
  }
}

class MyObserver extends WidgetsBindingObserver {
  final BuildContext context;
  MyObserver(this.context);

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        print('Приложение свернуто');
        print(imageCache.liveImageCount);
        await ImageSettings.precacheImages(context);
        break;
      case AppLifecycleState.resumed:
        print('Приложение развернуто');
        print(imageCache.liveImageCount);

        break;
      default:
        break;
    }
  }
}
