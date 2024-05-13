// ignore_for_file: file_names, unused_element

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

Widget patternBlock(String title, IconData icon, Widget widget,
    {double horizontal = 16}) {
  return DottedBorder(
    borderType: BorderType.RRect,
    radius: const Radius.circular(10),
    dashPattern: const [10, 10],
    color: Colors.lightBlueAccent.withOpacity(0.25),
    strokeWidth: 2,
    child: Container(
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
                child: Text(
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
    ),
  );
}
