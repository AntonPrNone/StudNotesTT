// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:stud_notes_tt/LocalBD/localSettingsService.dart';
import 'package:stud_notes_tt/Model/settingsModel.dart';
import 'patternBlockWidget.dart';

class ItemProfilePage extends StatefulWidget {
  const ItemProfilePage({super.key});

  @override
  State<ItemProfilePage> createState() => _ItemProfilePageState();
}

class _ItemProfilePageState extends State<ItemProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Профиль'),
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
                  'Подтверждённая почта',
                  Icons.check_circle,
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
          'Показывать галочку рядом с текстовым полем электронной почты в профиле, если она является подтвержённой',
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Показывать галочку подтверждения эл. почты',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(width: 10),
            Switch(
              activeTrackColor: Colors.deepPurpleAccent,
              value: SettingsModel.showCheckEmailProfile,
              onChanged: (bool value) {
                setState(() {
                  SettingsModel.showCheckEmailProfile = value;
                  LocalSettingsService.saveShowCheckEmailProfile();
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
