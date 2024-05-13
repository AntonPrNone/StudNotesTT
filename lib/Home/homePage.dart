// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:stud_notes_tt/Auth/authPage.dart';
import 'package:stud_notes_tt/Auth/authService.dart';
import 'package:stud_notes_tt/DB/eventDB.dart';
import 'package:stud_notes_tt/DB/examDB.dart';
import 'package:stud_notes_tt/DB/homeworkDB.dart';
import 'package:stud_notes_tt/DB/prepodsDB.dart';
import 'package:stud_notes_tt/DB/subjectDB.dart';
import 'package:stud_notes_tt/DB/timetableDB.dart';
import 'package:stud_notes_tt/Model/Observer/eventObserverClass.dart';
import 'package:stud_notes_tt/Model/Observer/examObserverClass.dart';
import 'package:stud_notes_tt/Model/Observer/homeworkObserverClass.dart';
import 'package:stud_notes_tt/Model/Observer/timetableObserverClass.dart';
import 'package:stud_notes_tt/Model/eventModel.dart';
import 'package:stud_notes_tt/Model/examModel.dart';
import 'package:stud_notes_tt/Model/homeworkModel.dart';
import 'package:stud_notes_tt/Model/settingsModel.dart';
import 'package:stud_notes_tt/Model/timetableItemModel.dart';
import 'package:stud_notes_tt/blanks.dart';
import '../Model/secondContainerDataModel.dart';
import '../LocalBD/localSettingsService.dart';
import '../Home/homePageElementsClass.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  int alphaMenu = SettingsModel.menuTransparency ? 122 : 255;
  bool menuTransparency = SettingsModel.menuTransparency;

  List<TimetableItem> timetableList = TimetableDB.getLastTimetableList();
  List<Homework> homeworkList = HomeworkDB.getLastHomeworksList();
  List<Exam> examList = ExamDB.getLastExamsList();
  List<Event> eventList = EventDB.getLastEventsList();

  @override
  void initState() {
    super.initState();
    homePageElementsClass.loadSecondContainerData();

    TimetableObserver().addListener(_updateDataTimetable);
    HomeworkObserver().addListener(_updateDataHomework);
    ExamObserver().addListener(_updateDataExam);
    EventObserver().addListener(_updateDataEvent);
  }

  @override
  void dispose() {
    super.dispose();
    TimetableObserver().removeListener(_updateDataTimetable);
    HomeworkObserver().removeListener(_updateDataHomework);
    ExamObserver().removeListener(_updateDataExam);
    EventObserver().removeListener(_updateDataEvent);
  }

  void _updateDataTimetable(List<TimetableItem> newData) {
    setState(() {
      timetableList = newData;
    });
  }

  void _updateDataHomework(List<Homework> newData) {
    setState(() {
      homeworkList = newData;
    });
  }

  void _updateDataExam(List<Exam> newData) {
    setState(() {
      examList = newData;
    });
  }

  void _updateDataEvent(List<Event> newData) {
    setState(() {
      eventList = newData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Меню'),
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
          icon: const Icon(
            Icons.account_circle,
            color: Colors.blue,
            size: 30,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings').then(
                (value) {
                  setState(
                    () {
                      if (menuTransparency != SettingsModel.menuTransparency) {
                        alphaMenu = SettingsModel.menuTransparency ? 122 : 255;
                        menuTransparency = SettingsModel.menuTransparency;
                      }
                    },
                  );
                },
              );
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.lightBlue,
            ),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Подтвердите выход'),
                    content: const Text(
                        'Вы уверены, что хотите выйти из учетной записи?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Отмена'),
                      ),
                      TextButton(
                        onPressed: () async {
                          AuthService.signOut();
                          PrepodDB.stopListeningToPrepodsStream();
                          SubjectDB.stopListeningToSubjectsStream();
                          TimetableDB.stopListeningToTimetableStream();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AuthPage()),
                            (route) =>
                                false, // Удалить все предыдущие маршруты из стека
                          );
                        },
                        child: const Text(
                          'Выйти',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/Imgs/bg2.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color: const Color.fromARGB(122, 0, 0, 0),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                container1(),
                daySummaryContainer_c2(),
                container2(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------

  Widget container1() {
    return Container(
      margin: const EdgeInsets.only(right: 16, left: 16, top: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(alphaMenu, 42, 18, 51),
            Color.fromARGB(alphaMenu, 20, 6, 20),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(2, 1),
          ),
        ],
      ),
      child: menu_c1(),
    );
  }

  Widget container2() {
    return Container(
      margin: const EdgeInsets.only(right: 16, left: 16, top: 0, bottom: 8),
      width: double.infinity,
      child: SingleChildScrollView(
        child: ReorderableListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final item = homePageElementsClass.secondContainerDataList
                  .removeAt(oldIndex);
              homePageElementsClass.secondContainerDataList
                  .insert(newIndex, item);
              // Сохранение порядка элементов при изменении
              LocalSettingsService.saveOrderPreviewMenu(homePageElementsClass
                  .secondContainerDataList
                  .map((item) => item.title)
                  .toList());
            });
          },
          proxyDecorator:
              (Widget child, int index, Animation<double> animation) {
            return ReorderableDelayedDragStartListener(
              key: Key('$index'),
              index: index,
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  final double opacityValue = Curves.easeInOutCubic
                      .transform(1 - animation.value)
                      .clamp(0.8, 1.0);
                  final double scaleValue = Curves.easeInOutCubic
                      .transform(1 - animation.value)
                      .clamp(0.95, 1.0);

                  return Opacity(
                    opacity: opacityValue,
                    child: Transform.scale(
                      scale: scaleValue,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  child: child,
                ),
              ),
            );
          },
          children: [
            for (var index = 0;
                index < homePageElementsClass.secondContainerDataList.length;
                index++)
              Container(
                key: Key('$index'),
                margin: const EdgeInsets.only(bottom: 16),
                child: summaryElContainer_c3(
                  homePageElementsClass.secondContainerDataList[index],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --------------------------------- C1 -------------------------------------

  Widget menu_c1() {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: homePageElementsClass.iconDataList.length,
      itemBuilder: (context, index) {
        return SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(64, 187, 134, 252),
                      Color.fromARGB(255, 35, 15, 43),
                    ],
                  ),
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  child: IconButton(
                    padding: const EdgeInsets.all(15),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              homePageElementsClass.iconDataList[index].page,
                        ),
                      );
                    },
                    icon: Icon(
                      size: 30,
                      homePageElementsClass.iconDataList[index].icon,
                      color: const Color(0xffbb86fc),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                homePageElementsClass.iconDataList[index].label,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  // --------------------------------- C2 -------------------------------------

  Widget daySummaryContainer_c2() {
    return Container(
      margin: const EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Сводка дня:',
            style: TextStyle(
              fontSize: 20,
              shadows: [
                Shadow(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                  offset: const Offset(2, 2),
                  blurRadius: 1,
                ),
              ],
            ),
          ),
          dateButton(context),
        ],
      ),
    );
  }

  Widget dateButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _selectDate(context);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Color.fromARGB(255, 41, 159, 255),
          ),
        ),
        elevation: 0,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today,
            size: 14,
            color: Color.fromARGB(255, 41, 159, 255),
          ),
          const SizedBox(width: 8),
          Text(
            '${selectedDate.day.toString().padLeft(2, '0')}.${selectedDate.month.toString().padLeft(2, '0')}.${selectedDate.year}',
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            formatWeekday(selectedDate),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      locale: const Locale('ru', 'RU'),
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // --------------------------------- C3 -------------------------------------

  Widget summaryElContainer_c3(SecondContainerDataModel dataModel) {
    Widget buildContainer() {
      switch (dataModel.title) {
        case ('Расписание занятий'):
          final filteredTimetable = timetableList.where((item) =>
              item.dayOfWeek == dayOfWeekConstRu[selectedDate.weekday - 1]);
          return filteredTimetable.isNotEmpty
              ? lessonsContainer(dataModel, filteredTimetable.toList())
              : noLessonsContainer(dataModel);
        case ('Домашнее задание'):
          final filteredHomeworks = homeworkList.where((item) =>
              item.deadline.year == selectedDate.year &&
              item.deadline.month == selectedDate.month &&
              item.deadline.day == selectedDate.day);
          return filteredHomeworks.isNotEmpty
              ? homeworksContainer(dataModel, filteredHomeworks.toList())
              : noLessonsContainer(dataModel);
        case ('Экзамены'):
          final filteredExams = examList.where((item) =>
              item.date.year == selectedDate.year &&
              item.date.month == selectedDate.month &&
              item.date.day == selectedDate.day);
          return filteredExams.isNotEmpty
              ? examsContainer(dataModel, filteredExams.toList())
              : noLessonsContainer(dataModel);
        case ('События'):
          final filteredEvents = eventList.where((item) =>
              item.date.year == selectedDate.year &&
              item.date.month == selectedDate.month &&
              item.date.day == selectedDate.day);
          return filteredEvents.isNotEmpty
              ? eventsContainer(dataModel, filteredEvents.toList())
              : noLessonsContainer(dataModel);
        default:
          return const Text('График не найден');
      }
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(2, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(
                      255, 20, 6, 20), // Конечный цвет (нижний правый угол)
                  Color.fromARGB(
                      255, 42, 18, 51), // Начальный цвет (верхний левый угол)
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                scheduleContainer(dataModel),
                buildContainer(),
                noActivitiesContainer(dataModel),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget scheduleContainer(SecondContainerDataModel dataModel) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 35, 15, 43),
                      Color.fromARGB(64, 187, 134, 252),
                    ],
                  ),
                ),
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    dataModel.icon,
                    size: 15,
                    color: const Color(0xffbb86fc),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                dataModel.title,
                style: const TextStyle(fontSize: 16, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const Icon(
            Icons.drag_handle_rounded,
            color:
                Color.fromARGB(122, 255, 255, 255), // Цвет иконки перемещения
          ),
        ],
      ),
    );
  }

  Widget noLessonsContainer(SecondContainerDataModel dataModel) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        image: const DecorationImage(
          alignment: Alignment.center,
          image: AssetImage("assets/Imgs/bgEmpty.png"),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              dataModel.icon,
              size: 30,
              color: const Color(0xffbb86fc),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              dataModel.noDataText,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(1),
                    offset: const Offset(2, 2),
                    blurRadius: 1,
                  ),
                ],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget noActivitiesContainer(SecondContainerDataModel dataModel) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8, right: 16, left: 16),
      child: Text(
        dataModel.bottomText,
        style: const TextStyle(
            fontSize: 14, color: Color.fromARGB(255, 122, 122, 122)),
      ),
    );
  }

  Widget lessonsContainer(
      SecondContainerDataModel dataModel, List<TimetableItem> timetable) {
    final filteredLessons = timetable.where((lesson) {
      return lesson.dayOfWeek == dayOfWeekConstRu[selectedDate.weekday - 1];
    }).toList();

    final visibleLessons = filteredLessons.take(4).toList();
    final hasMore = filteredLessons.length > 4;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: Colors.black.withOpacity(0.25),
      ),
      child: Column(
        children: [
          for (var i = 0; i < visibleLessons.length; i++)
            ListTile(
              leading: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                child: Center(
                  child: Text(
                    (i + 1).toString(),
                    style: const TextStyle(
                      color: Colors.purpleAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              title: Text(
                visibleLessons[i].subjectName,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: visibleLessons[i].room.isNotEmpty
                  ? Text(
                      visibleLessons[i].room,
                      style: TextStyle(color: Colors.white.withOpacity(0.75)),
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
              trailing: Text(
                  '${visibleLessons[i].startTime.format(context)} - ${visibleLessons[i].endTime.format(context)}'),
            ),
          if (hasMore)
            Center(
              child: Text(
                '...',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.5), fontSize: 22),
              ),
            ),
        ],
      ),
    );
  }

  Widget eventsContainer(
      SecondContainerDataModel dataModel, List<Event> events) {
    final filteredEvents = events.where((event) {
      return event.date.year == selectedDate.year &&
          event.date.month == selectedDate.month &&
          event.date.day == selectedDate.day;
    }).toList();

    final visibleEvents = filteredEvents.take(4).toList();
    final hasMore = filteredEvents.length > 4;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: Colors.black.withOpacity(0.25),
      ),
      child: Column(
        children: [
          for (var i = 0; i < visibleEvents.length; i++)
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(
                  dataModel.icon,
                  size: 15,
                  color: const Color(0xffbb86fc),
                ),
              ),
              title: Text(
                visibleEvents[i].name,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: visibleEvents[i].name.isNotEmpty
                  ? Text(
                      visibleEvents[i].place,
                      style: TextStyle(color: Colors.white.withOpacity(0.75)),
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
              trailing: Text(
                  '${visibleEvents[i].startTime.format(context)} - ${visibleEvents[i].endTime.format(context)}'),
            ),
          if (hasMore)
            Center(
              child: Text(
                '...',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.5), fontSize: 22),
              ),
            ),
        ],
      ),
    );
  }

  Widget examsContainer(SecondContainerDataModel dataModel, List<Exam> exams) {
    final filteredExams = exams.where((exam) {
      return exam.date.year == selectedDate.year &&
          exam.date.month == selectedDate.month &&
          exam.date.day == selectedDate.day;
    }).toList();

    final visibleExams = filteredExams.take(4).toList();
    final hasMore = filteredExams.length > 4;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: Colors.black.withOpacity(0.25),
      ),
      child: Column(
        children: [
          for (var i = 0; i < visibleExams.length; i++)
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(
                  dataModel.icon,
                  size: 15,
                  color: const Color(0xffbb86fc),
                ),
              ),
              title: Text(
                visibleExams[i].nameSubject,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: visibleExams[i].room.isNotEmpty
                  ? Text(
                      visibleExams[i].room,
                      style: TextStyle(color: Colors.white.withOpacity(0.75)),
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
              trailing: Text(
                  '${visibleExams[i].startTime.format(context)} - ${visibleExams[i].endTime.format(context)}'),
            ),
          if (hasMore)
            Center(
              child: Text(
                '...',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.5), fontSize: 22),
              ),
            ),
        ],
      ),
    );
  }

  Widget homeworksContainer(
      SecondContainerDataModel dataModel, List<Homework> homeworks) {
    final filteredHomeworks = homeworks.where((homework) {
      return homework.deadline.year == selectedDate.year &&
          homework.deadline.month == selectedDate.month &&
          homework.deadline.day == selectedDate.day;
    }).toList();

    final visibleHomeworks = filteredHomeworks.take(4).toList();
    final hasMore = filteredHomeworks.length > 4;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: Colors.black.withOpacity(0.25),
      ),
      child: Column(
        children: [
          for (var i = 0; i < visibleHomeworks.length; i++)
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(
                  dataModel.icon,
                  size: 15,
                  color: const Color(0xffbb86fc),
                ),
              ),
              title: Text(
                visibleHomeworks[i].nameSubject,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: visibleHomeworks[i].description.isNotEmpty
                  ? Text(
                      visibleHomeworks[i].description,
                      style: TextStyle(color: Colors.white.withOpacity(0.75)),
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
            ),
          if (hasMore)
            Center(
              child: Text(
                '...',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.5), fontSize: 22),
              ),
            ),
        ],
      ),
    );
  }
}
