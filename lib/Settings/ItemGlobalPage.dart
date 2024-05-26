// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stud_notes_tt/main.dart';
import 'patternBlockWidget.dart';

class ItemGlobalPage extends StatefulWidget {
  const ItemGlobalPage({super.key});

  @override
  State<ItemGlobalPage> createState() => _ItemGlobalPageState();
}

class _ItemGlobalPageState extends State<ItemGlobalPage> {
  late ThemeProvider themeProvider;
  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Общие настройки'),
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
                patternBlock('Кастомизация', Icons.palette_rounded, _block(),
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
        Row(
          children: [
            const Text(
              'Прозрачность диалоговых окон',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(width: 10),
            Switch(
              activeTrackColor: Colors.deepPurpleAccent,
              value: themeProvider.dialogOpacity,
              onChanged: (value) {
                themeProvider.dialogOpacity = value;
              },
            ),
          ],
        ),
      ],
    );
  }
}
