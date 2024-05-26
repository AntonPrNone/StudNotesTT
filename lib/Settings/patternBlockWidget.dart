// ignore_for_file: file_names

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

Widget patternBlock(String title, IconData icon, Widget widget,
    {double horizontal = 16, bool showAnimShimmer = false}) {
  Widget content = Container(
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: horizontal),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.5),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: showAnimShimmer
                  ? Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                      .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: false),
                      )
                      .shimmer(
                        angle: 45,
                        duration: const Duration(seconds: 2),
                        color: Colors.blue,
                      )
                      .shimmer(
                        angle: 45,
                        delay: 0.75.seconds,
                        duration: const Duration(seconds: 2),
                        color: Colors.cyan,
                      )
                  : Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(width: 10),
            Icon(
              icon,
              color: Colors.blue,
            ),
          ],
        ),
        const SizedBox(height: 15),
        widget,
      ],
    ),
  );

  return DottedBorder(
    borderType: BorderType.RRect,
    radius: const Radius.circular(10),
    dashPattern: const [10, 10],
    color: Colors.lightBlueAccent.withOpacity(0.25),
    strokeWidth: 2,
    child: !showAnimShimmer
        ? content
        : content
            .animate(
              onPlay: (controller) => controller.repeat(reverse: false),
            )
            .shimmer(
              angle: 45,
              duration: const Duration(seconds: 2),
              color: Colors.blue.withOpacity(0.5),
            )
            .shimmer(
              angle: 45,
              delay: 0.75.seconds,
              duration: const Duration(seconds: 2),
              color: Colors.cyan.withOpacity(0.5),
            ),
  );
}
