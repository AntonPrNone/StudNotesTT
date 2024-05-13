// ignore_for_file: prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, file_names, use_super_parameters, avoid_print, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:stud_notes_tt/DB/timetableDB.dart';
import 'package:stud_notes_tt/Model/settingsModel.dart';
import 'package:stud_notes_tt/Model/timetableItemModel.dart';

const Color purple = Color.fromARGB(255, 63, 45, 149);

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  late DateTime classEndTime;
  late DateTime endOfClasses;
  late DateTime endSchoolYear;

  @override
  void initState() {
    super.initState();
    _setTimers();
  }

  void _setTimers() {
    DateTime now = DateTime.now();
    int weekday = now.weekday;
    TimeOfDay currentTime = TimeOfDay.fromDateTime(now);
    List<TimetableItem> timetableList = TimetableDB.getLastTimetableList();
    TimetableItem? currentLesson;

    for (TimetableItem item in timetableList) {
      if (item.dayOfWeek == SettingsModel.dayOfWeekRu[weekday - 1].item1 &&
          currentTime.hour >= item.startTime.hour &&
          currentTime.minute >= item.startTime.minute &&
          currentTime.hour < item.endTime.hour) {
        currentLesson = item;
        break;
      }
    }

    if (currentLesson != null) {
      classEndTime = DateTime(now.year, now.month, now.day,
          currentLesson.endTime.hour, currentLesson.endTime.minute);
    } else {
      classEndTime = now;
    }

    List<TimetableItem> todayLessons = timetableList
        .where((item) =>
            item.dayOfWeek == SettingsModel.dayOfWeekRu[weekday - 1].item1)
        .toList();
    if (todayLessons.isNotEmpty) {
      TimetableItem lastLesson = todayLessons.last;
      endOfClasses = DateTime(now.year, now.month, now.day,
          lastLesson.endTime.hour, lastLesson.endTime.minute);
    } else {
      endOfClasses = now;
    }

    endSchoolYear = SettingsModel.endSchoolYear;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Время до'),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/Imgs/bg4.jpg',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 20),
              buildTimerFrame(
                context,
                description: 'До окончания занятия',
                endTime: classEndTime,
                format: CountDownTimerFormat.hoursMinutesSeconds,
              ),
              const SizedBox(height: 20),
              buildTimerFrame(
                context,
                description: 'До окончания учебного дня',
                endTime: endOfClasses,
                format: CountDownTimerFormat.hoursMinutesSeconds,
              ),
              const SizedBox(height: 20),
              buildTimerFrame(
                context,
                description: 'До конца учебного года',
                endTime: endSchoolYear,
                format: CountDownTimerFormat.daysOnly,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTimerFrame(
    BuildContext context, {
    required String description,
    required DateTime endTime,
    required CountDownTimerFormat format,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: purple.withOpacity(0.5),
        border: Border.all(
          width: 2,
          color: purple,
        ),
      ),
      child: Column(
        children: [
          Text(
            description,
            style: const TextStyle(
              fontSize: 20,
              letterSpacing: 0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          buildTimerBasic(
            format: format,
            endTime: endTime,
          ),
        ],
      ),
    );
  }

  Widget buildTimerBasic({
    required CountDownTimerFormat format,
    required DateTime endTime,
  }) {
    return TimerCountdown(
      format: format,
      endTime: endTime,
      onEnd: () {
        print("Таймер завершен");
      },
      timeTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w300,
        fontSize: 40,
        fontFeatures: [FontFeature.tabularFigures()],
      ),
      colonsTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w300,
        fontSize: 40,
        fontFeatures: [FontFeature.tabularFigures()],
      ),
      descriptionTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontFeatures: [FontFeature.tabularFigures()],
      ),
      spacerWidth: 0,
      daysDescription: "дней",
      hoursDescription: "часов",
      minutesDescription: "минут",
      secondsDescription: "секунд",
    );
  }
}
