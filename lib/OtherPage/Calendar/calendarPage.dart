// ignore_for_file: file_names, library_private_types_in_public_api
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stud_notes_tt/DB/eventDB.dart';
import 'package:stud_notes_tt/DB/examDB.dart';
import 'package:stud_notes_tt/DB/homeworkDB.dart';
import 'package:stud_notes_tt/Model/eventModel.dart';
import 'package:stud_notes_tt/Model/examModel.dart';
import 'package:stud_notes_tt/Model/homeworkModel.dart';
import 'package:stud_notes_tt/Model/settingsModel.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _selectedDate;
  late List<Event> _events;
  late List<Homework> _homeworks;
  late List<Exam> _exams;
  late CalendarFormat _calendarFormat = SettingsModel.formatCalendarMonth
      ? CalendarFormat.month
      : CalendarFormat.week;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _events = EventDB.getLastEventsList();
    _homeworks = HomeworkDB.getLastHomeworksList();
    _exams = ExamDB.getLastExamsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Календарь событий'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/Imgs/bg4.jpg',
            fit: BoxFit.cover,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(10),
                child: _buildCalendar(),
              ),
              _buildEventsList(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      daysOfWeekHeight: 18,
      locale: 'ru_RU',
      firstDay: DateTime(DateTime.now().year - 1),
      lastDay: DateTime(DateTime.now().year + 2),
      focusedDay: _selectedDate,
      calendarFormat: _calendarFormat,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Месяц',
        CalendarFormat.week: 'Неделя',
      },
      headerStyle: HeaderStyle(
        formatButtonDecoration: BoxDecoration(
            border: Border.fromBorderSide(
                BorderSide(color: Colors.blue.withOpacity(0.5))),
            borderRadius: const BorderRadius.all(Radius.circular(12.0))),
        titleCentered: true,
      ),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.deepPurple.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.deepPurpleAccent.withOpacity(0.75),
          shape: BoxShape.circle,
        ),
        todayTextStyle: const TextStyle(color: Colors.black),
        selectedTextStyle: const TextStyle(color: Colors.black),
      ),
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          if (day.weekday == DateTime.sunday ||
              day.weekday == DateTime.saturday) {
            final text = DateFormat.E('ru_RU').format(day);

            return Center(
              child: Text(
                text,
                style: TextStyle(color: Colors.redAccent.withOpacity(0.5)),
              ),
            );
          }
          return null;
        },
        markerBuilder: (context, date, events) {
          int eventsCount =
              _events.where((event) => isSameDay(event.date, date)).length;
          int homeworksCount = _homeworks
              .where((homework) => isSameDay(homework.deadline, date))
              .length;
          int examsCount =
              _exams.where((exam) => isSameDay(exam.date, date)).length;

          if (eventsCount > 0 || homeworksCount > 0 || examsCount > 0) {
            return _buildEventMarker(eventsCount, homeworksCount, examsCount);
          } else {
            return null;
          }
        },
      ),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDate = selectedDay;
        });
      },
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDate, day);
      },
      eventLoader: (day) {
        return _getEventsForDay(day).map((event) => 'Event').toList() +
            _getHomeworksForDay(day).map((homework) => 'Homework').toList() +
            _getExamsForDay(day).map((exam) => 'Exam').toList();
      },
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format == CalendarFormat.month
              ? CalendarFormat.month
              : CalendarFormat.week;
        });
      },
    );
  }

  Widget _buildEventMarker(
      int eventsCount, int homeworksCount, int examsCount) {
    List<Widget> markers = [];

    if (eventsCount > 0) {
      markers.add(_buildMarker(eventsCount, Colors.blue));
    }
    if (homeworksCount > 0) {
      markers.add(_buildMarker(homeworksCount, Colors.deepPurpleAccent));
    }
    if (examsCount > 0) {
      markers.add(_buildMarker(examsCount, Colors.redAccent));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: markers,
    );
  }

  Widget _buildMarker(int count, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Text(
        count.toString(),
        style: const TextStyle(
            fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events.where((event) {
      return isSameDay(event.date, day);
    }).toList();
  }

  List<Homework> _getHomeworksForDay(DateTime day) {
    return _homeworks.where((homework) {
      return isSameDay(homework.deadline, day);
    }).toList();
  }

  List<Exam> _getExamsForDay(DateTime day) {
    return _exams.where((exam) {
      return isSameDay(exam.date, day);
    }).toList();
  }

  Widget _buildEventsList() {
    List<Event> eventsOnSelectedDate = _getEventsForDay(_selectedDate);
    List<Homework> homeworksOnSelectedDate = _getHomeworksForDay(_selectedDate);
    List<Exam> examsOnSelectedDate = _getExamsForDay(_selectedDate);

    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (eventsOnSelectedDate.isNotEmpty)
            ..._buildEventsSection(eventsOnSelectedDate, Colors.blue),
          if (homeworksOnSelectedDate.isNotEmpty)
            ..._buildHomeworksSection(
                homeworksOnSelectedDate, Colors.deepPurpleAccent),
          if (examsOnSelectedDate.isNotEmpty)
            ..._buildExamsSection(examsOnSelectedDate, Colors.redAccent),
        ],
      ),
    );
  }

  List<Widget> _buildEventsSection(List<Event> events, Color indicatorColor) {
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Icon(
              Icons.event,
              color: indicatorColor,
            ),
            const SizedBox(width: 4),
            const Text(
              'События',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      ...events.map((event) {
        return Column(
          children: [
            DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              dashPattern: const [7, 7],
              color: indicatorColor.withOpacity(0.5),
              strokeWidth: 2,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: indicatorColor,
                  radius: 5,
                ),
                title: Text(
                  event.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    if (event.category.isNotEmpty)
                      Row(
                        children: [
                          const Icon(
                            Icons.category_rounded,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.category,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    if (event.place.isNotEmpty)
                      Row(
                        children: [
                          const Icon(
                            Icons.place_rounded,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.place,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    if (event.description.isNotEmpty)
                      Row(
                        children: [
                          const Icon(
                            Icons.description_rounded,
                            color: Colors.amberAccent,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.description,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                trailing: Text(
                  '${event.startTime.format(context)} - ${event.endTime.format(context)}',
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      }),
    ];
  }

  List<Widget> _buildHomeworksSection(
      List<Homework> homeworks, Color indicatorColor) {
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Icon(
              Icons.assignment_rounded,
              color: indicatorColor,
            ),
            const SizedBox(width: 4),
            const Text(
              'Домашние задания',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      ...homeworks.map((homework) {
        return Column(
          children: [
            DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              dashPattern: const [7, 7],
              color: indicatorColor.withOpacity(0.5),
              strokeWidth: 2,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: indicatorColor,
                  radius: 5,
                ),
                title: Text(
                  homework.nameSubject,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    if (homework.category.isNotEmpty)
                      Row(
                        children: [
                          const Icon(
                            Icons.category_rounded,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              homework.category,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    if (homework.description.isNotEmpty)
                      Row(
                        children: [
                          const Icon(
                            Icons.description_rounded,
                            color: Colors.amberAccent,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              homework.description,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      }),
    ];
  }

  List<Widget> _buildExamsSection(List<Exam> exams, Color indicatorColor) {
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Icon(
              Icons.school_rounded,
              color: indicatorColor,
            ),
            const SizedBox(width: 4),
            const Text(
              'Экзамены',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      ...exams.map((exam) {
        return Column(
          children: [
            DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              dashPattern: const [7, 7],
              color: indicatorColor.withOpacity(0.5),
              strokeWidth: 2,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: indicatorColor,
                  radius: 5,
                ),
                title: Text(
                  exam.nameSubject,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    if (exam.examCategory.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.category_rounded,
                            color: indicatorColor,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              exam.examCategory,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    if (exam.room.isNotEmpty)
                      Row(
                        children: [
                          const Icon(
                            Icons.place_rounded,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              exam.room,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    if (exam.description.isNotEmpty)
                      Row(
                        children: [
                          const Icon(
                            Icons.description_rounded,
                            color: Colors.amberAccent,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              exam.description,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                trailing: Text(
                  '${exam.startTime.format(context)} - ${exam.endTime.format(context)}',
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      }),
    ];
  }
}
