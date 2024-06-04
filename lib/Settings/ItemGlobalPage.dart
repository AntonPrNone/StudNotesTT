// ignore_for_file: file_names, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stud_notes_tt/Model/settingsModel.dart';
import 'package:stud_notes_tt/main.dart';
import 'patternBlockWidget.dart';

class ItemGlobalPage extends StatefulWidget {
  const ItemGlobalPage({super.key});

  @override
  State<ItemGlobalPage> createState() => _ItemGlobalPageState();
}

class _ItemGlobalPageState extends State<ItemGlobalPage> {
  late ThemeProvider themeProvider;
  bool isExpanded = false;
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
                patternBlock(
                    'Кастомизация', Icons.palette_rounded, _blockCust(),
                    showAnimShimmer: true),
                const SizedBox(
                  height: 16,
                ),
                patternBlock(
                  'Сохранение настроек',
                  Icons.save_rounded,
                  _blockSaveSettings(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _blockCust() {
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

  Widget _blockSaveSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionTile(
          childrenPadding: const EdgeInsets.only(bottom: 8),
          iconColor: Colors.blue,
          title: const Text('Настройки, которые будут сохранены:'),
          onExpansionChanged: (value) {
            isExpanded = value;
          },
          children: const [
            Text(
              'Порядок элементов сводки меню;\nПрозрачность диалоговых окон;\nГалочка эл. почты;\nУчебные дни недели;\nРасписание звонков;\nПрозрачность меню;\nРасписание: добавление преподавателя, дисциплины;\nДисциплины: добавление преподавателя;\nОграничение заметки преподавателя;\nАвтоудаление Д/З;\nАвтоудаление экзаменов;\nАвтоудаление событий;\nНачальный формат календаря;\nФормат статистики;\nОкончание учебного года',
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(Colors.blue.withOpacity(0.25))),
              onPressed: () async {
                var message = await SettingsModel.saveSettings();
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor:
                      const Color.fromARGB(255, 20, 20, 20).withOpacity(0.5),
                  content: Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ));
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.save_alt_rounded,
                    color: Colors.lightBlueAccent,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    'Сохранить',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(Colors.blue.withOpacity(0.25))),
              onPressed: () async {
                var message = await SettingsModel.loadSettings();
                Provider.of<ThemeProvider>(context).dialogOpacity =
                    SettingsModel.dialogOpacity;
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor:
                      const Color.fromARGB(255, 20, 20, 20).withOpacity(0.5),
                  content: Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ));
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.refresh,
                    color: Colors.lightBlueAccent,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    'Восстановить',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
