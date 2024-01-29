// ignore_for_file: prefer_const_constructors, use_super_parameters, library_private_types_in_public_api, file_names, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:stud_notes_tt/DB/prepodsDB.dart';

class PrepodsPage extends StatefulWidget {
  @override
  _PrepodsPageState createState() => _PrepodsPageState();
}

class _PrepodsPageState extends State<PrepodsPage> {
  late Stream<List<String>> prepodsStream;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    prepodsStream = PrepodDB.prepodsStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Преподаватели'),
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
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildShadowedText('Ваши преподаватели:'),
                SizedBox(height: 16.0),
                Expanded(
                  child: StreamBuilder<List<String>>(
                    initialData: PrepodDB.getLastPrepodsList(),
                    stream: prepodsStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text('Список преподавателей пуст'),
                        );
                      }

                      List<String> teachersList = snapshot.data!;

                      return ListView.builder(
                        itemCount: teachersList.length,
                        itemBuilder: (context, index) {
                          return _buildTeacherCard(teachersList[index]);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: _addTeacher,
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  Widget _buildShadowedText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          Shadow(
            color: Colors.black,
            blurRadius: 2.0,
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherCard(String teacherName) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.deepPurple, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _editTeacher(teacherName);
          },
          splashColor: Colors.deepPurple,
          borderRadius: BorderRadius.circular(8.0),
          child: ListTile(
            title: Text(
              teacherName,
              style: TextStyle(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                _deleteTeacher(teacherName);
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
      onConfirm: (String value) async {
        if (value.isNotEmpty) {
          await PrepodDB.addPrepod(value);
        }
      },
    );
  }

  void _editTeacher(String teacherName) {
    _showDialog(
      title: 'Редактировать преподавателя',
      hintText: 'ФИО преподавателя',
      initialValue: teacherName,
      onConfirm: (String value) async {
        if (value.isNotEmpty) {
          await PrepodDB.editPrepod(teacherName, value);
          print('Преподаватель успешно отредактирован: $value');
        }
      },
    );
  }

  void _deleteTeacher(String teacherName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Удалить преподавателя'),
          content: Text('Вы уверены, что хотите удалить этого преподавателя?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Отмена'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await PrepodDB.deletePrepod(teacherName);
              },
              child: Text('Удалить'),
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
    required Function(String) onConfirm,
  }) {
    _controller.text = initialValue;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: hintText,
              prefixIcon: Icon(Icons.person),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm(_controller.text);
              },
              child: Text('Подтвердить'),
            ),
          ],
        );
      },
    );
  }
}
