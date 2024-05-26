import 'package:flutter/material.dart';
import 'package:stud_notes_tt/LocalBD/localSettingsService.dart';
import 'package:stud_notes_tt/Model/settingsModel.dart';
import '../Other/blanks.dart';
import 'patternBlockWidget.dart';

class ItemTimerPage extends StatefulWidget {
  const ItemTimerPage({super.key});

  @override
  State<ItemTimerPage> createState() => _ItemTimerPageState();
}

class _ItemTimerPageState extends State<ItemTimerPage> {
  DateTime selectedDate = SettingsModel.endSchoolYear;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Время до'),
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
                  'Окончание учебного года',
                  Icons.timer_outlined,
                  _block(),
                  horizontal: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _block() {
    return Container(
      child: dateButton(
        context,
        setState,
        selectedDate,
      ),
    );
  }

  Widget dateButton(
      BuildContext context, StateSetter setState, DateTime initialDate) {
    return ElevatedButton(
      onPressed: () {
        _selectDate(context, setState, initialDate);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black.withOpacity(0.5),
        padding: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Color.fromARGB(255, 41, 159, 255),
          ),
        ),
        elevation: 0,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today,
            size: 14,
            color: Color.fromARGB(255, 41, 159, 255),
          ),
          const SizedBox(width: 8),
          Text(
            formatDate(initialDate),
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            formatWeekday(initialDate),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, StateSetter setState,
      DateTime initialDeadline) async {
    if (initialDeadline.isBefore(DateTime.now())) {
      initialDeadline = DateTime.now();
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      locale: const Locale('ru', 'RU'),
      initialDate: initialDeadline,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate != null) {
      setState(() {
        SettingsModel.endSchoolYear = pickedDate;
        LocalSettingsService.saveEndSchoolYear();
        selectedDate = pickedDate;
      });
    }
  }
}
