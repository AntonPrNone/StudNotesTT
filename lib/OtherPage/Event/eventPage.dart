// ignore_for_file: file_names, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:stud_notes_tt/DB/eventDB.dart';
import 'package:stud_notes_tt/Model/Observer/eventObserverClass.dart';
import 'package:stud_notes_tt/Model/eventModel.dart';
import 'package:stud_notes_tt/Model/settingsModel.dart';
import 'package:stud_notes_tt/blanks.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: 9, minute: 30);

  bool isEmptyNameController = false;

  List<Event> eventList = EventDB.getLastEventsList();

  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController placeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    EventObserver().addListener(_updateDataEvent);
    if (SettingsModel.autoDeleteExpiredEvent) {
      EventDB.deleteExpiredEvents();
    }
  }

  void _updateDataEvent(List<Event> newData) {
    setState(() {
      eventList = newData;
    });
  }

  @override
  void dispose() {
    EventObserver().removeListener(_updateDataEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<DateTime, List<Event>> groupedEvent = groupEventByDate(eventList);
    List<DateTime> sortedDates = groupedEvent.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('События'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/Imgs/bg2.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            color: const Color.fromARGB(122, 0, 0, 0),
          ),
          ListView(
            padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16),
            children: sortedDates.map((date) {
              List<Event> events = groupedEvent[date]!;
              bool isSingleCard = events.length == 1;
              bool isDatePassed = date
                  .isBefore(DateTime.now().subtract(const Duration(days: 1)));
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${formatDate(date)}, ${formatWeekday(date)}:',
                      style: TextStyle(
                        fontFamily: 'Comfortaa',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDatePassed
                            ? Colors.redAccent.withOpacity(0.5)
                            : Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: events.map((event) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: _buildEventCard(
                              event,
                              isSingleCard,
                              convertTimeOfDayToDateTime(
                                      event.date, event.startTime)
                                  .isBefore(DateTime.now()
                                      .subtract(const Duration(days: 1)))),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  Widget _buildEventCard(Event event, bool isSingleCard, bool expired) {
    // Изменить везде названия
    double cardWidth =
        isSingleCard ? MediaQuery.of(context).size.width - 32 : 300;
    return SizedBox(
      width: cardWidth,
      child: Card(
        elevation: 5.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: expired ? Colors.redAccent : Colors.deepPurple,
              width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              _editEvent(event);
            },
            splashColor: Colors.deepPurple,
            borderRadius: BorderRadius.circular(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${formatTime((event.startTime))} - ${formatTime(event.endTime)}',
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: (event.category.isNotEmpty ||
                                      event.place.isNotEmpty ||
                                      event.description.isNotEmpty)
                                  ? 8
                                  : 0),
                          child: Text(
                            event.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (event.category.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.category_rounded,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    event.category,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (event.place.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.room_rounded,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    event.place,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (event.description.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.note_rounded,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    event.description,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteEvent(event);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _addEvent() {
    _showDialog(
      title: 'Добавить событие',
      onConfirm: (Event newEvent) async {
        await EventDB.addEvent(newEvent);
      },
    );
  }

  void _editEvent(Event event) {
    _showDialog(
      title: 'Редактировать событие',
      event: event,
      onConfirm: (Event newEvent) async {
        await EventDB.editEvent(event, newEvent);
      },
    );
  }

  void _deleteEvent(Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтверждение'),
          content: Text(
              'Вы уверены, что хотите удалить событие «${event.description}»?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                EventDB.deleteEvent(
                    event.name, event.date, event.startTime, event.endTime);
              },
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );
  }

  void _showDialog({
    required String title,
    Event? event,
    required Function(Event) onConfirm,
  }) {
    nameController = TextEditingController(text: event?.name ?? '');
    descriptionController =
        TextEditingController(text: event?.description ?? '');
    categoryController = TextEditingController(text: event?.category ?? '');
    placeController = TextEditingController(text: event?.place ?? '');

    startTime = event?.startTime ?? startTime;
    endTime = event?.endTime ?? endTime;
    selectedDate = event?.date ?? selectedDate;

    isEmptyNameController = false;

    if (event?.date == null &&
        selectedDate
            .isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      selectedDate = DateTime.now();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Дата и время:',
                      style: TextStyle(fontSize: 16),
                    ),
                    dateButton(context, setState, selectedDate),
                    _buildTimePicker(),
                    TextField(
                      minLines: 1,
                      maxLines: 2,
                      controller: nameController,
                      decoration: InputDecoration(
                          labelText: 'Название события',
                          prefixIcon: const Icon(Icons.subject_rounded),
                          errorText: isEmptyNameController
                              ? 'Поле обязательно'
                              : null),
                      onChanged: (value) {
                        setState(() {
                          isEmptyNameController = value.isEmpty;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    autoCompleteTextField(
                        'Категория события',
                        categoryController,
                        eventCategorys,
                        Icons.category_rounded,
                        setState,
                        maxLines: 2),
                    const SizedBox(height: 16),
                    TextField(
                      controller: placeController,
                      decoration: InputDecoration(
                        labelText: 'Место',
                        prefixIcon: const Icon(Icons.room_rounded),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      minLines: 1,
                      maxLines: 3,
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Заметка',
                        prefixIcon: const Icon(Icons.note_rounded),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Отмена'),
                ),
                TextButton(
                  child: const Text('Подтвердить'),
                  onPressed: () {
                    if (nameController.text.isEmpty) {
                      setState(() {
                        isEmptyNameController = nameController.text.isEmpty;
                      });
                      return;
                    }

                    if (isTimeConflictingRange_Event(
                      startTime,
                      endTime,
                    )) {
                      showErrorDialog(
                          'Время начала должно быть раньше или равно времени окончания',
                          context);
                      return;
                    }

                    if (isTimeConflictingIntersects_Event(
                        selectedDate,
                        startTime,
                        endTime,
                        event?.startTime,
                        event?.endTime,
                        eventList)) {
                      showErrorDialog(
                          'Время пересекается с другим событием', context);
                      return;
                    }

                    Navigator.of(context).pop();
                    onConfirm(Event(
                            name: nameController.text,
                            category: categoryController.text,
                            date: selectedDate,
                            startTime: startTime,
                            endTime: endTime,
                            place: placeController.text,
                            description: descriptionController.text))
                        .then((_) {
                      {}
                    });
                  },
                ),
              ],
            );
          },
        );
      },
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
        selectedDate = pickedDate;
      });
    }
  }

  Widget _buildTimePicker() {
    return StatefulBuilder(
      builder: (context, setState) {
        String formattedStartTime = formatTime(startTime);
        String formattedEndTime = formatTime(endTime);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.access_time,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () async {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: startTime,
                    );

                    if (selectedTime != null) {
                      setState(() {
                        startTime = selectedTime;
                      });
                    }
                  },
                ),
                Text(
                  formattedStartTime,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(width: 12),
            Text(
              '-',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.access_time,
                      color: Theme.of(context).colorScheme.primary),
                  onPressed: () async {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: endTime,
                    );

                    if (selectedTime != null) {
                      setState(() {
                        endTime = selectedTime;
                      });
                    }
                  },
                ),
                Text(
                  formattedEndTime,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(width: 12),
          ],
        );
      },
    );
  }
}
