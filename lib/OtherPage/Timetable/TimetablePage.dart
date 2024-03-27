// ignore_for_file: prefer_const_constructors, file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:stud_notes_tt/DB/prepodsDB.dart';
import 'package:stud_notes_tt/DB/timetableDB.dart';
import 'package:stud_notes_tt/Model/Observer/timetableObserverClass.dart';
import 'package:stud_notes_tt/Model/prepodModel.dart';
import 'package:stud_notes_tt/Model/timetableItemModel.dart';
import 'package:stud_notes_tt/customIconsClass.dart';

class TimetablePage extends StatefulWidget {
  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  late PageController _pageController;
  int _currentPageIndex = 0;
  List<TimetableItem> timetableItemList = TimetableDB.getLastTimetableList();
  String selectedIconPath = 'assets/Icons/Subjects/SubjectChemistry1.png';
  List<String> teacherNames = PrepodDB.getPrepodNames();
  List<Prepod> teacherList = PrepodDB.getLastPrepodsList();

  TextEditingController nameController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  TextEditingController teacherController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController dayOfWeekController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);
    TimetableObserver().addListener(_updateDataTimetableItem);
    timetableItemList = TimetableDB.getLastTimetableList();
  }

  void _updateDataTimetableItem(List<TimetableItem> newData) {
    setState(() {
      timetableItemList = newData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dayOfWeekRu[_currentPageIndex]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          _showAddTimetableItemDialog(context);
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
            itemCount: dayOfWeekRu.length,
            onPageChanged: (int index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return buildDaySchedulePage(dayOfWeekRu[index]);
            },
          ),
          Positioned(
            bottom: 20, // Adjust position as needed
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
        children: List.generate(dayOfWeekRu.length, (index) {
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
    // Filter timetable list by selected day of week
    List<TimetableItem> filteredTimetable = timetableItemList
        .where((item) => item.dayOfWeek.toLowerCase() == weekday.toLowerCase())
        .toList();

    return SingleChildScrollView(
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        shrinkWrap: true, // Constrain ListView height
        itemCount: filteredTimetable.length,
        itemBuilder: (context, index) {
          return _buildTimetableCard(filteredTimetable[index]);
        },
      ),
    );
  }

  Widget _buildTimetableCard(TimetableItem timetableItem) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.deepPurple, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // _editSubject(subject);
          },
          splashColor: Colors.deepPurple,
          borderRadius: BorderRadius.circular(8.0),
          child: ListTile(
            title: Row(
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
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                    'Время: ${timetableItem.startTime.format(context)} - ${timetableItem.endTime.format(context)}'),
                if (timetableItem.room.isNotEmpty)
                  Text('Аудитория: ${timetableItem.room}'),
                if (timetableItem.teacher.isNotEmpty)
                  Text('Преподаватель: ${timetableItem.teacher}'),
                if (timetableItem.note.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      timetableItem.note,
                      style: TextStyle(color: Colors.white.withOpacity(0.5)),
                    ),
                  )
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _deleteTimetableItem(timetableItem);
              },
            ),
          ),
        ),
      ),
    );
  }

  void _addTimetableItem() {
    _showDialog(
      title: 'Добавить дисциплину',
      hintText: 'Название дисциплины',
      iconPath: selectedIconPath,
      onConfirm: (String subjectName,
          String room,
          String teacher,
          String note,
          String iconPath,
          String dayOfWeek,
          String startTime,
          String endTime) async {
        if (subjectName.isNotEmpty) {
          if (timetableItemList.any(
              (timetableItem) => timetableItem.subjectName == subjectName)) {
            _showErrorDialog('Дисциплина с данным названием уже существует');
            return;
          }
          await TimetableDB.addTimetableItem(
            TimetableItem(
              iconPath: iconPath,
              subjectName: subjectName,
              room: room,
              teacher: teacher,
              note: note,
              dayOfWeek: dayOfWeek,
              startTime: TimeOfDay(hour: 0, minute: 0),
              endTime: TimeOfDay(hour: 0, minute: 0),
            ),
          );
        }
      },
    );
  }

  void _editTimetableItem(TimetableItem timetableItem) {
    _showDialog(
      title: 'Редактировать дисциплину',
      hintText: 'Название дисциплины',
      iconPath: timetableItem.iconPath,
      initialName: timetableItem.subjectName,
      initialRoom: timetableItem.room,
      initialTeacher: timetableItem.teacher,
      initialNote: timetableItem.note,
      onConfirm: (String subjectName,
          String room,
          String teacher,
          String note,
          String iconPath,
          String dayOfWeek,
          String startTime,
          String endTime) async {
        if (subjectName.isNotEmpty) {
          if (timetableItemList
              .any((s) => s.subjectName == subjectName && s != timetableItem)) {
            _showErrorDialog('Дисциплина с данным названием уже существует');
            return;
          }
          await TimetableDB.editTimetableItem(
            timetableItem.subjectName,
            timetableItem.dayOfWeek,
            TimetableItem(
              iconPath: iconPath,
              subjectName: subjectName,
              room: room.isNotEmpty ? room : '',
              teacher: teacher.isNotEmpty ? teacher : '',
              note: note.isNotEmpty ? note : '',
              dayOfWeek: '',
              startTime: TimeOfDay(hour: 0, minute: 0),
              endTime: TimeOfDay(hour: 0, minute: 0),
            ),
          );
        }
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

  void _showAddTimetableItemDialog(BuildContext context) {
    String subjectName = '';
    String iconPath =
        'assets/Icons/Subjects/SubjectChemistry1.png'; // Default icon
    String startTime = '';
    String endTime = '';
    String room = '';
    String teacher = '';
    String note = '';

    // Get day of week for current page index
    String selectedDayOfWeek = dayOfWeekRu[_currentPageIndex];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Добавить элемент расписания"),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Show selected day of week in dialog
                Text('День недели: $selectedDayOfWeek'),
                TextField(
                  decoration: InputDecoration(labelText: 'Название предмета'),
                  onChanged: (value) {
                    subjectName = value;
                  },
                ),
                // Add fields for iconPath, room, teacher, and note
                // ...
                TextField(
                  decoration:
                      InputDecoration(labelText: 'Время начала (HH:MM)'),
                  onChanged: (value) {
                    startTime = value;
                  },
                ),
                TextField(
                  decoration:
                      InputDecoration(labelText: 'Время окончания (HH:MM)'),
                  onChanged: (value) {
                    endTime = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Добавить'),
              onPressed: () {
                // Create new timetable item
                TimetableItem newItem = TimetableItem(
                  dayOfWeek: selectedDayOfWeek,
                  subjectName: subjectName,
                  iconPath: iconPath,
                  startTime: TimeOfDay(
                    hour: int.parse(startTime.split(':')[0]),
                    minute: int.parse(startTime.split(':')[1]),
                  ),
                  endTime: TimeOfDay(
                    hour: int.parse(endTime.split(':')[0]),
                    minute: int.parse(endTime.split(':')[1]),
                  ),
                  room: room,
                  teacher: teacher,
                  note: note,
                );

                // Add item to database
                TimetableDB.addTimetableItem(newItem);

                // Close dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog({
    required String title,
    required String hintText,
    required String iconPath,
    String? initialName,
    String? initialRoom,
    String? initialTeacher,
    String? initialNote,
    String? dayOfWeek,
    String? startTime,
    String? endTime,
    required Function(
            String, String, String, String, String, String, String, String)
        onConfirm,
  }) {
    nameController = TextEditingController(text: initialName);
    roomController = TextEditingController(text: initialRoom);
    teacherController = TextEditingController(text: initialTeacher);
    noteController = TextEditingController(text: initialNote);
    dayOfWeekController = TextEditingController(text: dayOfWeek);
    startTimeController = TextEditingController(text: startTime);
    endTimeController = TextEditingController(text: endTime);
    bool isNameEmpty = false;
    selectedIconPath = iconPath;
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
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: hintText,
                        prefixIcon: Icon(Icons.subject),
                        errorText: isNameEmpty ? 'Поле обязательно' : null,
                      ),
                      onChanged: (value) {
                        setState(() {
                          isNameEmpty = value.isEmpty;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: roomController,
                      decoration: InputDecoration(
                        labelText: 'Аудитория',
                        prefixIcon: Icon(Icons.room),
                      ),
                    ),
                    SizedBox(height: 16),
                    autoCompleteWidget(initialTeacher, context),
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
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Отмена'),
                ),
                TextButton(
                  onPressed: () {
                    if (nameController.text.isEmpty) {
                      setState(() {
                        isNameEmpty = true;
                      });
                      return;
                    }

                    Navigator.of(context).pop();
                    onConfirm(
                            nameController.text,
                            roomController.text,
                            teacherController.text,
                            noteController.text,
                            selectedIconPath,
                            dayOfWeekController.text,
                            startTimeController.text,
                            endTimeController.text)
                        .then((_) {
                      if (!teacherNames.contains(teacherController.text) &&
                          teacherController.text.isNotEmpty) {
                        _showCreateTeacherDialog(teacherController.text);
                      }
                    });
                  },
                  child: const Text('Подтвердить'),
                ),
              ],
            );
          },
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

  Widget autoCompleteWidget(
    String? initialTeacher,
    BuildContext context,
  ) {
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
        return TextField(
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
          decoration: InputDecoration(
            labelText: 'Преподаватель',
            prefixIcon: Icon(Icons.person),
          ),
          onChanged: (String value) {
            teacherController.text = fieldTextEditingController.text;
          },
          onSubmitted: (String value) {
            onFieldSubmitted();
          },
        );
      },
      optionsMaxHeight: 150,
    );
  }

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
                    timetableItem.subjectName, timetableItem.dayOfWeek);
              },
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );
  }
}
