// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:stud_notes_tt/LocalBD/localSettingsService.dart';
import 'package:stud_notes_tt/Model/settingsModel.dart';
import 'patternBlockWidget.dart';

class ItemSubjectPage extends StatefulWidget {
  const ItemSubjectPage({super.key});

  @override
  State<ItemSubjectPage> createState() => _ItemSubjectPageState();
}

class _ItemSubjectPageState extends State<ItemSubjectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Дисциплины'),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/Imgs/bg1.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color: const Color.fromARGB(122, 0, 0, 0),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                patternBlock(
                  '«Элемент не найден»',
                  Icons.block_rounded,
                  _block(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _block() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Отображение диалогового окна с предложением добавить несуществующего:',
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text(
              'Преподавателя',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(width: 10),
            Switch(
              activeTrackColor: Colors.deepPurpleAccent,
              value: SettingsModel.showDialogAddInSubjectTeacher,
              onChanged: (bool value) {
                setState(() {
                  SettingsModel.showDialogAddInSubjectTeacher = value;
                  LocalSettingsService.saveShowDialogAddInSubjectTeacher();
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
