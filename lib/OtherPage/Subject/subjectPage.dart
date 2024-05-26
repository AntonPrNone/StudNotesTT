// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:stud_notes_tt/DB/prepodsDB.dart';
import 'package:stud_notes_tt/DB/subjectDB.dart';
import 'package:stud_notes_tt/Model/prepodModel.dart';
import 'package:stud_notes_tt/Model/settingsModel.dart';
import 'package:stud_notes_tt/Model/subjectModel.dart';
import 'package:stud_notes_tt/Model/Observer/prepodsObserverClass.dart';
import 'package:stud_notes_tt/Other/blanks.dart';
import '../../Model/Observer/subjectObserverClass.dart';
import '../../Other/customIconsClass.dart';

class SubjectPage extends StatefulWidget {
  const SubjectPage({super.key});

  @override
  _SubjectPageState createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  List<Subject> subjectList = SubjectDB.getLastSubjectsList();
  String selectedIconPath = 'assets/Icons/Subjects/SubjectChemistry1.png';
  List<String> teacherNames = PrepodDB.getPrepodNames();
  List<Prepod> teacherList = PrepodDB.getLastPrepodsList();

  TextEditingController nameController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  TextEditingController teacherController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SubjectObserver().addListener(_updateDataSubject);
    PrepodsObserver().addListener(_updateDataPrepods);
  }

  void _updateDataSubject(List<Subject> newData) {
    setState(() {
      subjectList = newData;
    });
  }

  void _updateDataPrepods(List<Prepod> newData) {
    setState(() {
      teacherList = newData;
      teacherNames = PrepodDB.getPrepodNames();
    });
  }

  @override
  void dispose() {
    SubjectObserver().removeListener(_updateDataSubject);
    PrepodsObserver().removeListener(_updateDataPrepods);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Дисциплины'),
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
          ListView.builder(
            padding: const EdgeInsets.all(16.0),
            shrinkWrap: true,
            itemCount: subjectList.length,
            itemBuilder: (context, index) {
              return _buildSubjectCard(subjectList[index]);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: _addSubject,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  Widget _buildSubjectCard(Subject subject) {
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
            _editSubject(subject);
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
                      Row(
                        children: [
                          Image.asset(
                            subject.iconPath,
                            width: 64,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              subject.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (subject.room.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.room,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  subject.room,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (subject.teacher.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.person,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  subject.teacher,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (subject.note.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            subject.note,
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.5)),
                          ),
                        )
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _deleteSubject(subject);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addSubject() {
    _showDialog(
      title: 'Добавить дисциплину',
      hintText: 'Название дисциплины',
      iconPath: selectedIconPath,
      onConfirm: (String name, String room, String teacher, String note,
          String iconPath) async {
        if (name.isNotEmpty) {
          if (subjectList.any((subject) => subject.name == name)) {
            showErrorDialog(
                'Дисциплина с данным названием уже существует', context);
            return;
          }
          await SubjectDB.addSubject(
            Subject(
              iconPath: iconPath,
              name: name,
              room: room,
              teacher: teacher,
              note: note,
            ),
          );
        }
      },
    );
  }

  void _editSubject(Subject subject) {
    _showDialog(
      title: 'Редактировать дисциплину',
      hintText: 'Название дисциплины',
      iconPath: subject.iconPath,
      initialName: subject.name,
      initialRoom: subject.room,
      initialTeacher: subject.teacher,
      initialNote: subject.note,
      onConfirm: (String name, String room, String teacher, String note,
          String iconPath) async {
        if (name.isNotEmpty) {
          if (subjectList.any((s) => s.name == name && s != subject)) {
            showErrorDialog(
                'Дисциплина с данным названием уже существует', context);
            return;
          }
          await SubjectDB.editSubject(
            subject.name,
            Subject(
              iconPath: iconPath,
              name: name,
              room: room.isNotEmpty ? room : '',
              teacher: teacher.isNotEmpty ? teacher : '',
              note: note.isNotEmpty ? note : '',
            ),
          );
        }
      },
    );
  }

  void _deleteSubject(Subject subject) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтверждение'),
          content: Text(
              'Вы уверены, что хотите удалить дисциплину «${subject.name}»?'),
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
                SubjectDB.deleteSubject(subject.name);
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
    required String hintText,
    required String iconPath,
    String? initialName,
    String? initialRoom,
    String? initialTeacher,
    String? initialNote,
    required Function(String, String, String, String, String) onConfirm,
  }) {
    nameController = TextEditingController(text: initialName);
    roomController = TextEditingController(text: initialRoom);
    teacherController = TextEditingController(text: initialTeacher);
    noteController = TextEditingController(text: initialNote);
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
                        prefixIcon: const Icon(Icons.subject),
                        errorText: isNameEmpty ? 'Поле обязательно' : null,
                      ),
                      onChanged: (value) {
                        setState(() {
                          isNameEmpty = value.isEmpty;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: roomController,
                      decoration: const InputDecoration(
                        labelText: 'Аудитория',
                        prefixIcon: Icon(Icons.room),
                      ),
                    ),
                    const SizedBox(height: 16),
                    autoCompleteWidget(context),
                    const SizedBox(height: 16),
                    TextField(
                      minLines: 1,
                      maxLines: 3,
                      controller: noteController,
                      decoration: const InputDecoration(
                        labelText: 'Заметка',
                        prefixIcon: Icon(Icons.note),
                      ),
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
                    ).then((_) {
                      if (!teacherNames.contains(teacherController.text) &&
                          teacherController.text.isNotEmpty &&
                          SettingsModel.showDialogAddInSubjectTeacher) {
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
        const Text(
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
          title: const Text('Выберите иконку'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter innerSetState) {
              return SizedBox(
                width: 300,
                height: 300.0,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
          decoration: const InputDecoration(
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
}
