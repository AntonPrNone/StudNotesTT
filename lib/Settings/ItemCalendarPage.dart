// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:stud_notes_tt/LocalBD/localSettingsService.dart';
import 'package:stud_notes_tt/Model/settingsModel.dart';
import 'patternBlockWidget.dart';

class ItemCalendarPage extends StatefulWidget {
  const ItemCalendarPage({super.key});

  @override
  State<ItemCalendarPage> createState() => _ItemCalendarPageState();
}

class _ItemCalendarPageState extends State<ItemCalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Календарь'),
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
                  'Формат календаря',
                  Icons.calendar_month_rounded,
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
          'Открывать календарь в одном из двух форматов: Месяц или Неделя',
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Формат (Месяц/Неделя)',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(width: 10),
            Switch(
              activeTrackColor: Colors.deepPurpleAccent,
              value: SettingsModel.formatCalendarMonth,
              onChanged: (bool value) {
                setState(() {
                  SettingsModel.formatCalendarMonth = value;
                  LocalSettingsService.saveFormatCalendarMonth();
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
