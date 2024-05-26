// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:stud_notes_tt/DB/examDB.dart';
import 'package:stud_notes_tt/DB/subjectDB.dart';
import 'package:stud_notes_tt/Model/Observer/examObserverClass.dart';
import 'package:stud_notes_tt/Model/examModel.dart';
import 'package:stud_notes_tt/Model/settingsModel.dart';
import '../../Other/blanks.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({super.key});
  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 9, minute: 30);

  bool isEmptyNameController = false;

  List<Exam> examList = ExamDB.getLastExamsList();
  List<String> subjectNames = SubjectDB.getSubjectsNames();

  TextEditingController nameSubjectController = TextEditingController();
  TextEditingController examCategoryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController roomController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ExamObserver().addListener(_updateDataExam);
    if (SettingsModel.autoDeleteExpiredExam) {
      ExamDB.deleteExpiredExams();
    }
  }

  void _updateDataExam(List<Exam> newData) {
    setState(() {
      examList = newData;
    });
  }

  @override
  void dispose() {
    ExamObserver().removeListener(_updateDataExam);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<DateTime, List<Exam>> groupedExam = groupExamByDate(examList);
    List<DateTime> sortedDates = groupedExam.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Экзамены'),
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
              List<Exam> exams = groupedExam[date]!;
              bool isSingleCard = exams.length == 1;
              bool isDatePassed = date
                  .isBefore(DateTime.now().subtract(const Duration(days: 0)));
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
                      children: exams.map((exam) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: _buildExamCard(
                              exam,
                              isSingleCard,
                              convertTimeOfDayToDateTime(
                                      exam.date, exam.endTime)
                                  .isBefore(DateTime.now()
                                      .subtract(const Duration(days: 0)))),
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
        onPressed: _addExam,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  Widget _buildExamCard(Exam exam, bool isSingleCard, bool expired) {
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
              _editExam(exam);
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
                              const Icon(
                                Icons.access_time,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${formatTime((exam.startTime))} - ${formatTime(exam.endTime)}',
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: (exam.examCategory.isNotEmpty ||
                                      exam.room.isNotEmpty ||
                                      exam.description.isNotEmpty)
                                  ? 8
                                  : 0),
                          child: Text(
                            exam.nameSubject,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (exam.examCategory.isNotEmpty)
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
                                    exam.examCategory,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (exam.room.isNotEmpty)
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
                                    exam.room,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (exam.description.isNotEmpty)
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
                                    exam.description,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
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
                      _deleteExam(exam);
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

  void _addExam() {
    _showDialog(
      title: 'Добавить экзамен',
      onConfirm: (Exam newExam) async {
        await ExamDB.addExam(newExam);
      },
    );
  }

  void _editExam(Exam exam) {
    _showDialog(
      title: 'Редактировать экзамен',
      exam: exam,
      onConfirm: (Exam newExam) async {
        await ExamDB.editExam(exam, newExam);
      },
    );
  }

  void _deleteExam(Exam exam) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтверждение'),
          content: Text(
              'Вы уверены, что хотите удалить экзамен «${exam.description}»?'),
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
                ExamDB.deleteExam(
                    exam.nameSubject, exam.date, exam.startTime, exam.endTime);
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
    Exam? exam,
    required Function(Exam) onConfirm,
  }) {
    nameSubjectController =
        TextEditingController(text: exam?.nameSubject ?? '');
    descriptionController =
        TextEditingController(text: exam?.description ?? '');
    examCategoryController =
        TextEditingController(text: exam?.examCategory ?? '');
    roomController = TextEditingController(text: exam?.room ?? '');

    startTime = exam?.startTime ?? startTime;
    endTime = exam?.endTime ?? endTime;
    selectedDate = exam?.date ?? selectedDate;

    isEmptyNameController = false;

    if (exam?.date == null &&
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
                      'Срок сдачи:',
                      style: TextStyle(fontSize: 16),
                    ),
                    dateButton(context, setState, selectedDate),
                    _buildTimePicker(),
                    autoCompleteTextField(
                        'Название дисциплины',
                        nameSubjectController,
                        subjectNames,
                        Icons.subject_rounded,
                        setState,
                        isEmptyController: isEmptyNameController,
                        maxLines: 2),
                    const SizedBox(height: 16),
                    autoCompleteTextField(
                        'Категория экзамена',
                        examCategoryController,
                        examCategorys,
                        Icons.category_rounded,
                        setState,
                        maxLines: 2),
                    const SizedBox(height: 16),
                    TextField(
                      controller: roomController,
                      decoration: const InputDecoration(
                        labelText: 'Аудитория',
                        prefixIcon: Icon(Icons.room_rounded),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      minLines: 1,
                      maxLines: 3,
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Заметка',
                        prefixIcon: Icon(Icons.note_rounded),
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
                    if (nameSubjectController.text.isEmpty) {
                      setState(() {
                        isEmptyNameController =
                            nameSubjectController.text.isEmpty;
                      });
                      return;
                    }

                    if (isTimeConflictingRange_Exam(
                      startTime,
                      endTime,
                    )) {
                      showErrorDialog(
                          'Время начала должно быть раньше или равно времени окончания',
                          context);
                      return;
                    }

                    if (isTimeConflictingIntersects_Exam(
                        selectedDate,
                        startTime,
                        endTime,
                        exam?.startTime,
                        exam?.endTime,
                        examList)) {
                      showErrorDialog(
                          'Время пересекается с другим экзаменом', context);
                      return;
                    }

                    Navigator.of(context).pop();
                    onConfirm(Exam(
                            nameSubject: nameSubjectController.text,
                            examCategory: examCategoryController.text,
                            date: convertTimeOfDayToDateTime(
                                selectedDate, endTime),
                            startTime: startTime,
                            endTime: endTime,
                            room: roomController.text,
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
      pickedDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
      setState(() {
        selectedDate = pickedDate!;
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
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(width: 12),
            const Text(
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
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(width: 12),
          ],
        );
      },
    );
  }
}
