import 'package:flutter/material.dart';
import 'package:stud_notes_tt/LocalBD/localSettingsService.dart';
import '../Model/settingsModel.dart';
import 'patternBlockWidget.dart';

class ItemMenuPage extends StatefulWidget {
  const ItemMenuPage({super.key});

  @override
  State<ItemMenuPage> createState() => _ItemMenuPageState();
}

class _ItemMenuPageState extends State<ItemMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Меню'),
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
                patternBlock('Персонализация', Icons.palette_rounded, _block(),
                    showAnimShimmer: true),
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
          'Прозрачность фона блока меню на домашней странице',
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text(
              'Прозрачность (50%)',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(width: 10),
            Switch(
              activeTrackColor: Colors.deepPurpleAccent,
              value: SettingsModel.menuTransparency,
              onChanged: (bool value) {
                setState(() {
                  SettingsModel.menuTransparency = value;
                  LocalSettingsService.saveMenuTransparency();
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
