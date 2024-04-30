// ignore_for_file: prefer_const_constructors, file_names, use_key_in_widget_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stud_notes_tt/DB/prepodsDB.dart';
import 'package:stud_notes_tt/DB/subjectDB.dart';
import 'package:stud_notes_tt/DB/timetableDB.dart';
import 'package:stud_notes_tt/Model/Observer/prepodsObserverClass.dart';
import 'package:stud_notes_tt/Model/Observer/subjectObserverClass.dart';
import 'package:stud_notes_tt/Model/Observer/timetableObserverClass.dart';
import 'package:stud_notes_tt/Model/prepodModel.dart';
import 'package:stud_notes_tt/Model/settingsModel.dart';
import 'package:stud_notes_tt/Model/subjectModel.dart';
import 'package:stud_notes_tt/Model/timetableItemModel.dart';
import 'package:stud_notes_tt/customIconsClass.dart';
import 'package:intl/intl.dart';

class TimetablePage extends StatefulWidget {
  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  late PageController _pageController;
  int _currentPageIndex = 0;
  bool isEmptyNameController = false;
  String selectedIconPath = 'assets/Icons/Subjects/SubjectChemistry1.png';

  List<TimetableItem> timetableItemList = TimetableDB.getLastTimetableList();
  List<Subject> subjectList = SubjectDB.getLastSubjectsList();
  List<String> subjectNames = SubjectDB.getSubjectsNames();
  List<Prepod> teacherList = PrepodDB.getLastPrepodsList();
  List<String> teacherNames = PrepodDB.getPrepodNames();

  TextEditingController nameController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  TextEditingController teacherController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  String selectedDayOfWeek = 'Понедельник';

  TimeOfDay startTime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: 0, minute: 0);

  late DateTime _startDate;
  late TimeOfDay currentTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);
    TimetableObserver().addListener(_updateDataTimetableItem);
    SubjectObserver().addListener(_updateDataSubject);
    PrepodsObserver().addListener(_updateDataPrepods);
    timetableItemList = TimetableDB.getLastTimetableList();
    subjectList = SubjectDB.getLastSubjectsList();
    teacherList = PrepodDB.getLastPrepodsList();

    _startDate =
        DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
    currentTime = getCurrentTime();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    TimetableObserver().removeListener(_updateDataTimetableItem);
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      _updateCurrentPair();
    });
  }

  void _updateCurrentPair() {
    setState(() {
      currentTime = getCurrentTime();
    });
  }

  void _updateDataTimetableItem(List<TimetableItem> newData) {
    setState(() => timetableItemList = newData);
  }

  void _updateDataSubject(List<Subject> newData) {
    setState(() {
      subjectList = newData;
      subjectNames = SubjectDB.getSubjectsNames();
    });
  }

  void _updateDataPrepods(List<Prepod> newData) {
    setState(() {
      teacherList = newData;
      teacherNames = PrepodDB.getPrepodNames();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                Text(
                  SettingsModel.dayOfWeekRu[_currentPageIndex].item1,
                ),
                if (_currentPageIndex == DateTime.now().weekday - 1)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 2,
                    child: Container(
                      color: Colors.blue,
                    ),
                  ),
              ],
            ),
            Spacer(),
            Text(
              DateFormat('dd.MM.yyyy').format(_startDate.add(Duration(
                  days:
                      SettingsModel.dayOfWeekRu[_currentPageIndex].item2 - 1))),
              style: TextStyle(
                  fontSize: 16,
                  color: _currentPageIndex == DateTime.now().weekday - 1
                      ? Colors.blue
                      : Colors.white),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          _showDialog(
              timetableItem: TimetableItem(
                  dayOfWeek: SettingsModel.dayOfWeekRu[_currentPageIndex].item1,
                  iconPath: selectedIconPath),
              isEditing: false);
        },
        child: const Icon(Icons.add),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/Imgs/bg2.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            color: const Color.fromARGB(122, 0, 0, 0),
          ),
          PageView.builder(
            controller: _pageController,
            itemCount: SettingsModel.dayOfWeekRu.length,
            onPageChanged: (int index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return buildDaySchedulePage(
                  SettingsModel.dayOfWeekRu[index].item1);
            },
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: _buildPageIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(SettingsModel.dayOfWeekRu.length, (index) {
          return GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPageIndex == index
                    ? Colors.deepPurpleAccent
                    : Colors.grey.withOpacity(0.5),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget buildDaySchedulePage(String weekday) {
    List<TimetableItem> filteredTimetable = timetableItemList
        .where((item) => item.dayOfWeek.toLowerCase() == weekday.toLowerCase())
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      shrinkWrap: true,
      itemCount: filteredTimetable.length,
      itemBuilder: (context, index) {
        return _buildTimetableCard(filteredTimetable[index], index + 1);
      },
    );
  }

  Widget _buildTimetableCard(TimetableItem timetableItem, int index) {
    final startTime = timetableItem.startTime;
    final endTime = timetableItem.endTime;
    final currentDayOfWeek = getCurrentDayOfWeek();
    final isCurrentDayOfWeek = currentDayOfWeek == timetableItem.dayOfWeek;

    final isCurrentTimeInPair = currentTime.hour > startTime.hour ||
        (currentTime.hour == startTime.hour &&
            currentTime.minute >= startTime.minute);
    final isCurrentTimeBeforeEnd = currentTime.hour < endTime.hour ||
        (currentTime.hour == endTime.hour &&
            currentTime.minute < endTime.minute);
    final isCurrentPair = isCurrentTimeInPair && isCurrentTimeBeforeEnd;
    final isActiveItem = isCurrentPair && isCurrentDayOfWeek;

    return Card(
      elevation: isActiveItem ? 2 : 5,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isActiveItem ? Colors.deepPurpleAccent : Colors.deepPurple,
          width: isActiveItem ? 3.0 : 2.0,
        ),
        borderRadius: BorderRadius.circular(isActiveItem ? 16.0 : 8.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showDialog(timetableItem: timetableItem, isEditing: true);
          },
          splashColor: Colors.deepPurple,
          borderRadius: BorderRadius.circular(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 2.0,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  index.toString(),
                                  style: TextStyle(
                                    color: Colors.purpleAccent,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.access_time,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${formatTime(timetableItem.startTime)} - ${formatTime(timetableItem.endTime)}',
                              style: TextStyle(
                                  color: isActiveItem
                                      ? Colors.lightBlue
                                      : Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Image.asset(
                              timetableItem.iconPath,
                              width: 64,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                timetableItem.subjectName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (timetableItem.room.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.room,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  timetableItem.room,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (timetableItem.teacher.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  timetableItem.teacher,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (timetableItem.note.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            timetableItem.note,
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.5)),
                          ),
                        )
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _deleteTimetableItem(timetableItem);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TimeOfDay getCurrentTime() =>
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

  String getCurrentDayOfWeek() =>
      SettingsModel.dayOfWeekRu[DateTime.now().weekday - 1].item1;

  void _deleteTimetableItem(TimetableItem timetableItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтверждение'),
          content: Text(
              'Вы уверены, что хотите удалить дисциплину из расписания «${timetableItem.subjectName}»?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                TimetableDB.deleteTimetableItem(
                    timetableItem.subjectName,
                    timetableItem.dayOfWeek,
                    timetableItem.startTime,
                    timetableItem.endTime);
              },
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );
  }

  void _showDialog({
    required TimetableItem timetableItem,
    required bool isEditing,
  }) {
    nameController = TextEditingController(text: timetableItem.subjectName);
    roomController = TextEditingController(text: timetableItem.room);
    teacherController = TextEditingController(text: timetableItem.teacher);
    noteController = TextEditingController(text: timetableItem.note);
    isEmptyNameController = false;
    selectedDayOfWeek = timetableItem.dayOfWeek;
    selectedIconPath = timetableItem.iconPath;
    String title =
        isEditing ? 'Редактировать дисциплину' : 'Добавить дисциплину';

    if (isEditing) {
      startTime = timetableItem.startTime;
      endTime = timetableItem.endTime;
    } else {
      List<TimetableItem> itemsForDayOfWeek = timetableItemList
          .where((item) => item.dayOfWeek == timetableItem.dayOfWeek)
          .toList();
      int lastIndex = itemsForDayOfWeek.length;
      if (lastIndex <= SettingsModel.timetableItemTimeList.length - 1) {
        TimetableItemTime lastItem =
            SettingsModel.timetableItemTimeList[lastIndex];
        startTime = lastItem.startTime;
        endTime = lastItem.endTime;
      } else {
        startTime = timetableItem.startTime;
        endTime = timetableItem.endTime;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildIconPicker(setState),
                    _buildTimePicker(),
                    autoCompleteSubject(timetableItem, setState),
                    SizedBox(height: 16),
                    TextField(
                      controller: roomController,
                      decoration: InputDecoration(
                        labelText: 'Аудитория',
                        prefixIcon: Icon(Icons.room),
                      ),
                    ),
                    SizedBox(height: 16),
                    autoCompleteTeacher(),
                    SizedBox(height: 16),
                    TextField(
                      minLines: 1,
                      maxLines: 3,
                      controller: noteController,
                      decoration: InputDecoration(
                        labelText: 'Заметка',
                        prefixIcon: Icon(Icons.note),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Отмена'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Подтвердить'),
                  onPressed: () async {
                    if (nameController.text.isEmpty) {
                      setState(() {
                        isEmptyNameController = true;
                      });
                      return;
                    }

                    TimetableItem updatedItem = TimetableItem(
                      subjectName: nameController.text,
                      room: roomController.text,
                      teacher: teacherController.text,
                      note: noteController.text,
                      dayOfWeek: selectedDayOfWeek,
                      startTime: startTime,
                      endTime: endTime,
                      iconPath: selectedIconPath,
                    );

                    if (isTimeConflictingRange_TimetableItem(updatedItem)) {
                      _showErrorDialog(
                          'Время начала должно быть раньше или равно времени окончания');
                      return;
                    }

                    if (isTimeConflictingIntersects_TimetableItem(
                        updatedItem, timetableItem, timetableItemList)) {
                      _showErrorDialog(
                          'Время пересекается с другой дисциплиной');
                      return;
                    }

                    Navigator.of(context).pop();

                    if (isEditing) {
                      await TimetableDB.editTimetableItem(
                          timetableItem.subjectName,
                          timetableItem.dayOfWeek,
                          updatedItem);
                    } else {
                      await TimetableDB.addTimetableItem(updatedItem);
                      if (!teacherNames.contains(teacherController.text) &&
                          teacherController.text.isNotEmpty) {
                        _showCreateTeacherDialog(teacherController.text);
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTimePicker() {
    return StatefulBuilder(
      builder: (context, setState) {
        String formattedStartTime = formatTime(startTime);
        String formattedEndTime = formatTime(endTime);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.access_time,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () async {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: startTime,
                    );

                    if (selectedTime != null) {
                      setState(() {
                        startTime = selectedTime;
                      });
                    }
                  },
                ),
                Text(
                  formattedStartTime,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(width: 12),
            Text(
              '-',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.access_time,
                      color: Theme.of(context).colorScheme.primary),
                  onPressed: () async {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: endTime,
                    );

                    if (selectedTime != null) {
                      setState(() {
                        endTime = selectedTime;
                      });
                    }
                  },
                ),
                Text(
                  formattedEndTime,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(width: 12),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ошибка'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showCreateTeacherDialog(String teacherName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Преподаватель не найден'),
          content: Text('Создать преподавателя «$teacherName»?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await PrepodDB.addPrepod(Prepod(name: teacherName, note: ''));
                teacherNames.add(teacherName);
              },
              child: const Text('Создать'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildIconPicker(StateSetter setState) {
    return Row(
      children: [
        Text(
          'Иконка:  ',
          style: TextStyle(fontSize: 16),
        ),
        GestureDetector(
          onTap: () {
            _showIconPickerDialog(setState);
          },
          child: CircleAvatar(
            radius: 32,
            backgroundColor: Colors.black.withOpacity(0.25),
            backgroundImage: AssetImage(selectedIconPath),
          ),
        ),
      ],
    );
  }

  void _showIconPickerDialog(StateSetter setState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Выберите иконку'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter innerSetState) {
              return SizedBox(
                width: 300,
                height: 300.0,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                  itemCount: CustomIcons.subjectIconPaths.length,
                  itemBuilder: (context, index) {
                    String iconName =
                        CustomIcons.subjectIconPaths.keys.elementAt(index);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIconPath =
                              CustomIcons.subjectIconPaths[iconName]!;
                        });
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.25),
                        backgroundImage:
                            AssetImage(CustomIcons.subjectIconPaths[iconName]!),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget autoCompleteTeacher() {
    return Autocomplete<String>(
      initialValue: teacherController.value,
      optionsBuilder: (TextEditingValue textEditingValue) {
        final filteredOptions = teacherNames.where((String option) {
          return option
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        }).toList();
        return filteredOptions;
      },
      onSelected: (String value) {
        teacherController.text = value;
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) {
        fieldTextEditingController.text = teacherController.text;

        return TextField(
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
          decoration: InputDecoration(
            labelText: 'Преподаватель',
            prefixIcon: Icon(Icons.person),
          ),
          onChanged: (String value) {
            teacherController.text = value;
          },
          onSubmitted: (String value) {
            onFieldSubmitted();
          },
        );
      },
      optionsMaxHeight: 150,
    );
  }

  Widget autoCompleteSubject(
      TimetableItem timetableItem, StateSetter setState) {
    return Autocomplete<String>(
      initialValue: nameController.value,
      optionsBuilder: (TextEditingValue textEditingValue) {
        final filteredOptions = subjectNames.where((String option) {
          return option
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        }).toList();
        return filteredOptions;
      },
      onSelected: (String value) {
        setState(() {
          nameController.text = value;
          isEmptyNameController = false;
        });
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) {
        bool subjectExists =
            subjectNames.contains(fieldTextEditingController.text);
        Color iconColor =
            subjectExists ? Theme.of(context).colorScheme.primary : Colors.grey;

        return TextField(
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
          decoration: InputDecoration(
            labelText: 'Название дисциплины',
            prefixIcon: IconButton(
              icon: Icon(Icons.menu),
              color: iconColor,
              onPressed: () {
                SubjectDB.getSubjectByName(nameController.text).then((subject) {
                  if (subject != null) {
                    setState(() {
                      roomController.text = subject.room;
                      teacherController.text = subject.teacher;
                      selectedIconPath = subject.iconPath;
                    });
                  }
                });
              },
            ),
            errorText: isEmptyNameController && nameController.text.isEmpty
                ? 'Поле обязательно'
                : null,
          ),
          onChanged: (String value) {
            setState(() {
              nameController.text = fieldTextEditingController.text;
              isEmptyNameController = true;
              iconColor = subjectNames.contains(value)
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey;
            });
          },
          onSubmitted: (String value) {
            onFieldSubmitted();
          },
        );
      },
      optionsMaxHeight: 150,
    );
  }
}
