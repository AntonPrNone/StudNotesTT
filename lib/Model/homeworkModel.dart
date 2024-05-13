// ignore_for_file: file_names

class Homework {
  final String nameSubject;
  final String description;
  final DateTime deadline;
  final String category;

  Homework({
    required this.nameSubject,
    required this.description,
    required this.deadline,
    required this.category,
  });
}

List<String> homeworkCategorys = [
  'Устно',
  'Теория',
  'Письменно',
  'Практика',
  'Доклад',
  'Выступление',
  'Презентация',
  'Семинар',
  'Конспект',
  'Реферат',
  'Эссе',
  'Отчёт',
  'Подготовка',
  'На ПК',
  'Другое'
];

Map<DateTime, List<Homework>> groupHomeworkByDate(List<Homework> homeworkList) {
  Map<DateTime, List<Homework>> groupedHomework = {};
  for (var homework in homeworkList) {
    DateTime date = DateTime(
        homework.deadline.year, homework.deadline.month, homework.deadline.day);
    if (groupedHomework.containsKey(date)) {
      groupedHomework[date]!.add(homework);
    } else {
      groupedHomework[date] = [homework];
    }
  }
  return groupedHomework;
}
