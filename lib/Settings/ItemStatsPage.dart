// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:stud_notes_tt/LocalBD/localSettingsService.dart';
import 'package:stud_notes_tt/Model/settingsModel.dart';
import 'patternBlockWidget.dart';

class ItemStatsPage extends StatefulWidget {
  const ItemStatsPage({super.key});

  @override
  State<ItemStatsPage> createState() => _ItemStatsPageState();
}

class _ItemStatsPageState extends State<ItemStatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Статистика'),
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
                  'Формат статистики',
                  Icons.percent_rounded,
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
          'Показывать относительные (проценты) или абсолютные (числа) значения на графике общего количества событий',
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Формат\n(Абсолютный/Относительный)',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(width: 10),
            Switch(
              activeTrackColor: Colors.deepPurpleAccent,
              value: SettingsModel.showPercentageStats,
              onChanged: (bool value) {
                setState(() {
                  SettingsModel.showPercentageStats = value;
                  LocalSettingsService.saveShowPercentageStats();
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
