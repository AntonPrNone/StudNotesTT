// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:stud_notes_tt/LocalBD/localSettingsService.dart';
import 'package:stud_notes_tt/Model/settingsModel.dart';
import 'patternBlockWidget.dart';

class ItemEventPage extends StatefulWidget {
  const ItemEventPage({super.key});

  @override
  State<ItemEventPage> createState() => _ItemEventPageState();
}

class _ItemEventPageState extends State<ItemEventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Cобытия'),
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
          'Автоматически удалять события, истекшие по сроку. Зачистка будет происходить при заходе на страницу',
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Автоудаление истекших событий',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(width: 10),
            Switch(
              activeTrackColor: Colors.deepPurpleAccent,
              value: SettingsModel.autoDeleteExpiredEvent,
              onChanged: (bool value) {
                setState(() {
                  SettingsModel.autoDeleteExpiredEvent = value;
                  LocalSettingsService.saveAutoDeleteExpiredEvent();
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
