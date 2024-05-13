// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:stud_notes_tt/LocalBD/localSettingsService.dart';
import 'package:stud_notes_tt/Model/settingsModel.dart';
import 'patternBlockWidget.dart';

class ItemPrepodPage extends StatefulWidget {
  const ItemPrepodPage({super.key});

  @override
  State<ItemPrepodPage> createState() => _ItemPrepodPageState();
}

class _ItemPrepodPageState extends State<ItemPrepodPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Преподаватели'),
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
                  'Карточка преподавателя',
                  Icons.group_rounded,
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
          'Ограничить высоту карточек, посредством ограничения показа на карточке заметки к преподавателю в размере одной строки',
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text(
              'Ограничение заметки в 1 строку',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(width: 10),
            Switch(
              activeTrackColor: Colors.deepPurpleAccent,
              value: SettingsModel.maxLines1NotePrepod,
              onChanged: (bool value) {
                setState(() {
                  SettingsModel.maxLines1NotePrepod = value;
                  LocalSettingsService.saveMaxLines1NotePrepod();
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
