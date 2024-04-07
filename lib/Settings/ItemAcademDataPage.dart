// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:stud_notes_tt/LocalBD/localSettingsService.dart';
import 'package:stud_notes_tt/Model/settingsModel.dart';
import 'package:stud_notes_tt/Model/timetableItemModel.dart';
import 'patternBlockWidget.dart';

class ItemAcademData extends StatefulWidget {
  @override
  State<ItemAcademData> createState() => _ItemAcademDataState();
}

class _ItemAcademDataState extends State<ItemAcademData> {
  final List<bool> _selectedDays = List<bool>.filled(dayOfWeekConstRu.length, false);

  @override
  void initState() {
    super.initState();

    for (var day in SettingsModel.dayOfWeekRu) {
      int index = dayOfWeekConstRu.indexOf(day);
      if (index != -1) {
        _selectedDays[index] = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Академические данные'),
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
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                patternBlock(
                  'Учебные дни недели',
                  Icons.calendar_month,
                  _customizationBlock(),
                  horizontal: 10,
                ),
                SizedBox(
                  height: 16,
                ),
                patternBlock(
                  'Расписание занятий',
                  Icons.calendar_view_day,
                  _timetableBlock(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _customizationBlock() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < dayOfWeekConstRu.length; i++)
            _customizationListItem(dayOfWeekConstRu[i], i),
        ],
      ),
    );
  }

  Widget _customizationListItem(String day, int index) {
    final bool isSelected = SettingsModel.dayOfWeekRu.contains(dayOfWeekConstRu[index]);

    return Column(
      children: [
        Text(
          dayOfWeekConstCutRu[index],
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        Checkbox(
          value: isSelected,
          onChanged: (newValue) {
            setState(() {
              if (newValue!) {
                if (!isSelected) {
                  SettingsModel.dayOfWeekRu.add(dayOfWeekConstRu[index]);
                  SettingsModel.dayOfWeekRu.sort(
                    (a, b) => dayOfWeekConstRu.indexOf(a).compareTo(dayOfWeekConstRu.indexOf(b)),
                  );
                }
              } else {
                if (SettingsModel.dayOfWeekRu.length > 1) {
                  SettingsModel.dayOfWeekRu.remove(dayOfWeekConstRu[index]);
                } else {
                  return;
                }
              }
            });

            LocalSettingsService.saveDayOfWeekRu();
          },
          activeColor: Colors.purpleAccent,
        ),
      ],
    );
  }

  Widget _timetableBlock() {
    List<TimetableItemTime> sortedList = List.from(SettingsModel.timetableItemTimeList);
    sortedList.sort((a, b) {
      if (a.endTime.hour != b.endTime.hour) {
        return a.endTime.hour.compareTo(b.endTime.hour);
      } else {
        return a.endTime.minute.compareTo(b.endTime.minute);
      }
    });

    return SizedBox(
      height: 200,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: sortedList.length + 1,
        itemBuilder: (context, index) {
          if (index < sortedList.length) {
            final item = sortedList[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          color: Colors.purpleAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  _buildTimePicker(item),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        SettingsModel.timetableItemTimeList
                            .removeAt(SettingsModel.timetableItemTimeList.indexOf(item));
                      });
                    },
                  ),
                ],
              ),
            );
          } else {
            return ElevatedButton(
              onPressed: _buildTimePickerDialog,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.deepPurple.withOpacity(0.5),
                ),
              ),
              child: Icon(
                Icons.add,
                color: Colors.blue,
              ),
            );
          }
        },
      ),
    );
  }

  void _buildTimePickerDialog() {
    TimeOfDay startTime = TimeOfDay(hour: 8, minute: 0);
    TimeOfDay endTime = TimeOfDay(hour: 9, minute: 30);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Добавления элемента расписания'),
              content:
                  _buildTimePickerRow(startTime, endTime, (selectedStartTime, selectedEndTime) {
                setState(() {
                  startTime = selectedStartTime;
                  endTime = selectedEndTime;
                });
              }),
              actions: <Widget>[
                TextButton(
                  child: const Text('Отмена'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Подтвердить'),
                  onPressed: () {
                    addTimetableItem(startTime, endTime);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTimePickerRow(TimeOfDay initialStartTime, TimeOfDay initialEndTime,
      Function(TimeOfDay, TimeOfDay) onTimeSelected) {
    String formattedStartTime = formatTime(initialStartTime);
    String formattedEndTime = formatTime(initialEndTime);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeSelectorButton(
          initialStartTime,
          (selectedTime) {
            onTimeSelected(selectedTime, initialEndTime);
          },
        ),
        Text(
          formattedStartTime,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(width: 12),
        Text(
          '-',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        _buildTimeSelectorButton(
          initialEndTime,
          (selectedTime) {
            onTimeSelected(initialStartTime, selectedTime);
          },
        ),
        Text(
          formattedEndTime,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(width: 12),
      ],
    );
  }

  Widget _buildTimeSelectorButton(TimeOfDay initialTime, Function(TimeOfDay) onTimeSelected) {
    return IconButton(
      icon: Icon(
        Icons.access_time,
        color: Theme.of(context).colorScheme.primary,
      ),
      onPressed: () async {
        final selectedTime = await showTimePicker(
          context: context,
          initialTime: initialTime,
        );

        if (selectedTime != null) {
          onTimeSelected(selectedTime);
        }
      },
    );
  }

  void addTimetableItem(TimeOfDay startTime, TimeOfDay endTime) {
    setState(() {
      TimetableItemTime newTimetableItem =
          TimetableItemTime(startTime: startTime, endTime: endTime);
      if (isTimeConflictingRange_TimetableItemTime(newTimetableItem)) {
        _showErrorDialog(
            'Некорректный временной диапазон: время начала должно быть раньше или равно времени окончания');
      } else if (isTimeConflictingIntersects_TimetableItemTime(newTimetableItem)) {
        _showErrorDialog('Время пересекается с другим элементом');
      } else {
        SettingsModel.timetableItemTimeList.add(newTimetableItem);
        LocalSettingsService.saveTimetableItemTimeList();
        Navigator.of(context).pop();
      }
    });
  }

  Widget _buildTimePicker(TimetableItemTime item) {
    String formattedStartTime = formatTime(item.startTime);
    String formattedEndTime = formatTime(item.endTime);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeSelectorIconButton(
          item.startTime,
          (selectedTime) {
            setState(() {
              TimeOfDay newStartTime = selectedTime;
              TimeOfDay newEndTime = item.endTime;

              if (isTimeConflictingRange_TimetableItemTime(
                  TimetableItemTime(startTime: newStartTime, endTime: newEndTime))) {
                _showErrorDialog('Время начала должно быть раньше или равно времени окончания');
                return;
              }

              if (isTimeConflictingIntersects_TimetableItemTime(
                  TimetableItemTime(startTime: newStartTime, endTime: newEndTime), item)) {
                _showErrorDialog('Время пересекается с другой дисциплиной');
                return;
              }

              item.startTime = newStartTime;
              LocalSettingsService.saveTimetableItemTimeList();
            });
          },
        ),
        Text(
          formattedStartTime,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(width: 12),
        Text(
          '-',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        _buildTimeSelectorIconButton(
          item.endTime,
          (selectedTime) {
            setState(() {
              TimeOfDay newStartTime = item.startTime;
              TimeOfDay newEndTime = selectedTime;

              if (isTimeConflictingRange_TimetableItemTime(
                  TimetableItemTime(startTime: newStartTime, endTime: newEndTime))) {
                _showErrorDialog('Время окончания должно быть позже или равно времени начала');
                return;
              }

              if (isTimeConflictingIntersects_TimetableItemTime(
                  TimetableItemTime(startTime: newStartTime, endTime: newEndTime), item)) {
                _showErrorDialog('Время пересекается с другой дисциплиной');
                return;
              }

              item.endTime = newEndTime;
              LocalSettingsService.saveTimetableItemTimeList();
            });
          },
        ),
        Text(
          formattedEndTime,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(width: 12),
      ],
    );
  }

  Widget _buildTimeSelectorIconButton(TimeOfDay initialTime, Function(TimeOfDay) onTimeSelected) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.access_time,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () async {
            final selectedTime = await showTimePicker(
              context: context,
              initialTime: initialTime,
            );

            if (selectedTime != null) {
              onTimeSelected(selectedTime);
            }
          },
        ),
      ],
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ошибка'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
