// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:stud_notes_tt/DB/prepodsDB.dart';
import 'package:stud_notes_tt/Model/prepodModel.dart';
import 'package:stud_notes_tt/Model/settingsModel.dart';
import '../../Model/Observer/prepodsObserverClass.dart';
import '../../Other/blanks.dart';

class PrepodsPage extends StatefulWidget {
  const PrepodsPage({super.key});

  @override
  _PrepodsPageState createState() => _PrepodsPageState();
}

class _PrepodsPageState extends State<PrepodsPage> {
  late Stream<List<Prepod>> prepodsStream;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  List<Prepod> teachersList = PrepodDB.getLastPrepodsList();
  @override
  void initState() {
    super.initState();
    PrepodsObserver().addListener(_updateData);
    teachersList = PrepodDB.getLastPrepodsList();
  }

  void _updateData(List<Prepod> newData) {
    setState(() {
      teachersList = newData;
    });
  }

  @override
  void dispose() {
    PrepodsObserver().removeListener(_updateData);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Преподаватели'),
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
            itemCount: teachersList.length,
            itemBuilder: (context, index) {
              return _buildTeacherCard(teachersList[index]);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: _addTeacher,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  Widget _buildTeacherCard(Prepod teacher) {
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
            _editTeacher(teacher);
          },
          splashColor: Colors.deepPurple,
          borderRadius: BorderRadius.circular(8.0),
          child: ListTile(
            title: Text(
              teacher.name,
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: teacher.note.isNotEmpty
                ? Text(
                    maxLines: SettingsModel.maxLines1NotePrepod ? 1 : null,
                    overflow: SettingsModel.maxLines1NotePrepod
                        ? TextOverflow.ellipsis
                        : null,
                    teacher.note,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 14,
                    ),
                  )
                : null,
            trailing: IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                _deleteTeacher(teacher.name);
              },
            ),
          ),
        ),
      ),
    );
  }

  void _addTeacher() {
    _showDialog(
      title: 'Добавить преподавателя',
      hintText: 'ФИО преподавателя',
      onConfirm: (String name, String note) async {
        if (name.isNotEmpty) {
          if (teachersList.any((teacher) => teacher.name == name)) {
            showErrorDialog(
                'Преподаватель с данным ФИО уже существует', context);
            return;
          }
          await PrepodDB.addPrepod(Prepod(name: name, note: note));
        }
      },
    );
  }

  void _editTeacher(Prepod teacher) {
    _showDialog(
      title: 'Редактировать преподавателя',
      hintText: 'ФИО преподавателя',
      initialValue: teacher.name,
      initialNote: teacher.note,
      onConfirm: (String name, String note) async {
        if (name.isNotEmpty) {
          await PrepodDB.editPrepod(teacher.name, name, note);
          print('Преподаватель успешно отредактирован: $name');
        }
      },
    );
  }

  void _deleteTeacher(String teacherName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Удалить преподавателя'),
          content:
              const Text('Вы уверены, что хотите удалить этого преподавателя?'),
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
                await PrepodDB.deletePrepod(teacherName);
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
    String initialValue = '',
    String initialNote = '',
    required Function(String, String) onConfirm,
  }) {
    _controller.text = initialValue;
    _noteController.text = initialNote;

    bool isNameEmpty = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'ФИО',
                      prefixIcon: const Icon(Icons.person),
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
                    minLines: 1,
                    maxLines: 3,
                    controller: _noteController,
                    decoration: const InputDecoration(
                      labelText: 'Заметка',
                      prefixIcon: Icon(Icons.note),
                    ),
                  ),
                ],
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
                    if (_controller.text.isEmpty) {
                      setState(() {
                        isNameEmpty = true;
                      });
                      return;
                    }
                    Navigator.of(context).pop();
                    onConfirm(_controller.text, _noteController.text);
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
}
