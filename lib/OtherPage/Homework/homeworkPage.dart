// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:stud_notes_tt/DB/homeworkDB.dart';
import 'package:stud_notes_tt/DB/subjectDB.dart';
import 'package:stud_notes_tt/Model/Observer/homeworkObserverClass.dart';
import 'package:stud_notes_tt/Model/homeworkModel.dart';
import 'package:stud_notes_tt/Model/settingsModel.dart';
import 'package:stud_notes_tt/blanks.dart';

class HomeworkPage extends StatefulWidget {
  const HomeworkPage({super.key});
  @override
  _HomeworkPageState createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<HomeworkPage> {
  DateTime selectedDate = DateTime.now();
  DateTime deadlineController = DateTime.now();

  bool isEmptyNameController = false;
  bool isDescriptionEmpty = false;

  List<Homework> homeworkList = HomeworkDB.getLastHomeworksList();
  List<String> homeworkDescriptions = HomeworkDB.getHomeworksDescriptions();
  List<String> subjectNames = SubjectDB.getSubjectsNames();

  TextEditingController nameSubjectController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    HomeworkObserver().addListener(_updateDataHomework);
    if (SettingsModel.autoDeleteExpiredHomework) {
      HomeworkDB.deleteExpiredHomeworks();
    }
  }

  void _updateDataHomework(List<Homework> newData) {
    setState(() {
      homeworkList = newData;
    });
  }

  @override
  void dispose() {
    HomeworkObserver().removeListener(_updateDataHomework);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<DateTime, List<Homework>> groupedHomework =
        groupHomeworkByDate(homeworkList);
    List<DateTime> sortedDates = groupedHomework.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Д/З'),
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
          ListView(
            padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16),
            children: sortedDates.map((date) {
              List<Homework> homeworks = groupedHomework[date]!;
              bool isSingleCard = homeworks.length == 1;
              bool isDeadlinePassed = date
                  .isBefore(DateTime.now().subtract(const Duration(days: 1)));
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${formatDate(date)}, ${formatWeekday(date)}:',
                      style: TextStyle(
                        fontFamily: 'Comfortaa',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDeadlinePassed
                            ? Colors.redAccent.withOpacity(0.5)
                            : Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: homeworks.map((homework) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: _buildHomeworkCard(
                              homework,
                              isSingleCard,
                              homework.deadline.isBefore(DateTime.now()
                                  .subtract(const Duration(days: 1)))),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addHomework,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  Widget _buildHomeworkCard(
      Homework homework, bool isSingleCard, bool expired) {
    double cardWidth =
        isSingleCard ? MediaQuery.of(context).size.width - 32 : 300;
    return SizedBox(
      width: cardWidth,
      child: Card(
        elevation: 5.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: expired ? Colors.redAccent : Colors.deepPurple,
              width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              _editHomework(homework);
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
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            homework.nameSubject,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.note_rounded,
                                color: Colors.blue,
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
                        ),
                        if (homework.category.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
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
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteHomework(homework);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _addHomework() {
    _showDialog(
      title: 'Добавить Д/З',
      onConfirm: (String nameSubject, String description, DateTime deadline,
          String category) async {
        if (nameSubject.isNotEmpty) {
          if (homeworkList.any((s) =>
              s.nameSubject == nameSubject && s.description == description)) {
            showErrorDialog(
                'Д/З с данным названием и описанием уже существует', context);
            return;
          }
          await HomeworkDB.addHomework(
            Homework(
              nameSubject: nameSubject,
              description: description.isNotEmpty ? description : '',
              deadline: deadline,
              category: category.isNotEmpty ? category : '',
            ),
          );
        }
      },
    );
  }

  void _editHomework(Homework homework) {
    _showDialog(
      title: 'Редактировать Д/З',
      initialNameSubject: homework.nameSubject,
      initialDescription: homework.description,
      initialDeadline: homework.deadline,
      initialCategory: homework.category,
      onConfirm: (String nameSubject, String description, DateTime deadline,
          String category) async {
        if (nameSubject.isNotEmpty) {
          if (homeworkList.any((s) =>
              s.nameSubject == nameSubject &&
              s.description == description &&
              s != homework)) {
            showErrorDialog(
                'Д/З с данным названием и описанием уже существует', context);
            return;
          }
          await HomeworkDB.editHomework(
            homework.nameSubject,
            homework.description,
            Homework(
              nameSubject: nameSubject,
              description: description.isNotEmpty ? description : '',
              deadline: deadline,
              category: category.isNotEmpty ? category : '',
            ),
          );
        }
      },
    );
  }

  void _deleteHomework(Homework homework) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтверждение'),
          content: Text(
              'Вы уверены, что хотите удалить Д/З «${homework.description}»?'),
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
                HomeworkDB.deleteHomework(
                    homework.nameSubject, homework.description);
              },
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );
  }

  void _showDialog({
    required String title,
    String? initialNameSubject,
    String? initialDescription,
    DateTime? initialDeadline,
    String? initialCategory,
    required Function(String, String, DateTime, String) onConfirm,
  }) {
    nameSubjectController = TextEditingController(text: initialNameSubject);
    descriptionController = TextEditingController(text: initialDescription);
    categoryController = TextEditingController(text: initialCategory);

    isEmptyNameController = false;
    isDescriptionEmpty = false;

    selectedDate = initialDeadline ?? selectedDate;

    if (initialDeadline == null &&
        selectedDate
            .isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      selectedDate = DateTime.now();
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Срок сдачи:',
                      style: TextStyle(fontSize: 16),
                    ),
                    dateButton(context, setState, selectedDate),
                    autoCompleteTextField(
                      'Название дисциплины',
                      nameSubjectController,
                      subjectNames,
                      Icons.subject_rounded,
                      setState,
                      isEmptyController: isEmptyNameController,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      minLines: 1,
                      maxLines: 5,
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Описание',
                        prefixIcon: const Icon(Icons.note_rounded),
                        errorText:
                            isDescriptionEmpty ? 'Поле обязательно' : null,
                      ),
                      onChanged: (value) {
                        setState(() {
                          isDescriptionEmpty = value.isEmpty;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    autoCompleteTextField(
                      'Категория',
                      categoryController,
                      homeworkCategorys,
                      Icons.category_rounded,
                      setState,
                    ),
                    const SizedBox(height: 16),
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
                    if (nameSubjectController.text.isEmpty ||
                        descriptionController.text.isEmpty) {
                      setState(() {
                        isEmptyNameController =
                            nameSubjectController.text.isEmpty;
                        isDescriptionEmpty = descriptionController.text.isEmpty;
                      });
                      return;
                    }

                    Navigator.of(context).pop();
                    onConfirm(
                      nameSubjectController.text,
                      descriptionController.text,
                      selectedDate,
                      categoryController.text,
                    ).then((_) {
                      {}
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

  Widget dateButton(
      BuildContext context, StateSetter setState, DateTime initialDeadline) {
    initialDeadline = initialDeadline;
    return ElevatedButton(
      onPressed: () {
        _selectDate(context, setState, initialDeadline);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black.withOpacity(0.5),
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
            formatDate(initialDeadline),
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            formatWeekday(initialDeadline),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, StateSetter setState,
      DateTime initialDeadline) async {
    if (initialDeadline.isBefore(DateTime.now())) {
      initialDeadline = DateTime.now();
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      locale: const Locale('ru', 'RU'),
      initialDate: initialDeadline,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }
}
