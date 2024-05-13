// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:stud_notes_tt/LocalBD/localSettingsService.dart';
import 'package:stud_notes_tt/Model/settingsModel.dart';
import 'patternBlockWidget.dart';

class ItemExamPage extends StatefulWidget {
  const ItemExamPage({super.key});

  @override
  State<ItemExamPage> createState() => _ItemExamPageState();
}

class _ItemExamPageState extends State<ItemExamPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Экзамены'),
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
                  'Автоудаление',
                  Icons.auto_delete_outlined,
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
          'Автоматически удалять экзамены, истекшие по сроку. Зачистка будет происходить при заходе на страницу',
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Автоудаление истекших экзаменов',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(width: 10),
            Switch(
              activeTrackColor: Colors.deepPurpleAccent,
              value: SettingsModel.autoDeleteExpiredExam,
              onChanged: (bool value) {
                setState(() {
                  SettingsModel.autoDeleteExpiredExam = value;
                  LocalSettingsService.saveAutoDeleteExpiredExam();
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
