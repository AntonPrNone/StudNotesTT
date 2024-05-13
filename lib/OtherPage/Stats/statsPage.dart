// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stud_notes_tt/DB/examDB.dart';
import 'package:stud_notes_tt/DB/homeworkDB.dart';
import 'package:stud_notes_tt/DB/timetableDB.dart';
import 'package:stud_notes_tt/Model/settingsModel.dart';
import 'package:stud_notes_tt/Model/timetableItemModel.dart';
import '../../DB/eventDB.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  List<TimetableItem> timetable = [];
  int eventCount = 0;
  int examCount = 0;
  int homeworkCount = 0;
  bool showPercentage = SettingsModel.showPercentageStats;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    timetable = TimetableDB.getLastTimetableList();
    eventCount = EventDB.getLastEventsList().length;
    examCount = ExamDB.getLastExamsList().length;
    homeworkCount = HomeworkDB.getLastHomeworksList().length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/Imgs/bg4.jpg',
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 350,
                    child: _buildLessonsChart(),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 350,
                    child: _buildEventsChart(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonsChart() {
    // Подсчитываем количество занятий по дням недели
    List<int> lessonsPerDay =
        List.filled(7, 0); // Создаем список с 7 элементами, заполненный 0
    for (var lesson in timetable) {
      lessonsPerDay[dayOfWeekConstRu.indexOf(lesson.dayOfWeek)]++;
    }
    double averageLessons =
        lessonsPerDay.reduce((a, b) => a + b) / lessonsPerDay.length;

    return Card(
      color: Colors.black.withOpacity(0.75),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Количество занятий по дням недели',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipRoundedRadius: 8,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.toInt()} зан.',
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  barGroups: lessonsPerDay.asMap().entries.map((entry) {
                    int index = entry.key;
                    int count = entry.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: count.toDouble(),
                          color: Colors.deepPurpleAccent,
                          width: 16,
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final int index = value.toInt();
                          if (index >= 0 && index < lessonsPerDay.length) {
                            return Text(
                              lessonsPerDay[index].toString(),
                              style: const TextStyle(color: Colors.blue),
                            );
                          } else {
                            return const Text('');
                          }
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final int index = value.toInt();
                          if (index >= 0 &&
                              index < dayOfWeekConstCutRu.length) {
                            return Text(dayOfWeekConstCutRu[index]);
                          } else {
                            return const Text('');
                          }
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(value.toInt().toString());
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Среднее количество занятий: ${averageLessons.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsChart() {
    int totalCount = homeworkCount + examCount + eventCount;
    List<PieChartSectionData> sections = [
      PieChartSectionData(
        value: homeworkCount.toDouble(),
        title: showPercentage
            ? 'Д/З: ${((homeworkCount / totalCount) * 100).toStringAsFixed(1)}%'
            : 'Д/З: $homeworkCount',
        color: Colors.redAccent,
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: examCount.toDouble(),
        title: showPercentage
            ? 'Экзамены: ${((examCount / totalCount) * 100).toStringAsFixed(1)}%'
            : 'Экзамены: $examCount',
        color: Colors.blue,
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: eventCount.toDouble(),
        title: showPercentage
            ? 'События: ${((eventCount / totalCount) * 100).toStringAsFixed(1)}%'
            : 'События: $eventCount',
        color: Colors.purple,
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];

    return Card(
      color: Colors.black.withOpacity(0.75),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Общее количество событий',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SizedBox(
                height: 400,
                child: PieChart(
                  PieChartData(
                    sections: sections,
                    centerSpaceRadius: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
