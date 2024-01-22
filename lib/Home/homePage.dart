// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names

import 'package:flutter/material.dart';
import 'package:stud_notes_tt/Auth/authPage.dart';
import 'package:stud_notes_tt/Auth/authService.dart';
import 'package:stud_notes_tt/Home/predmeti.dart';
import '../Model/settingsModel.dart';
import '../localSettingsService.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<IconDataModel> iconDataList = [
    IconDataModel(icon: Icons.schedule, label: 'Расписание', page: HomePage()),
    IconDataModel(icon: Icons.menu_book, label: 'Дисциплины', page: Predmeti()),
    IconDataModel(icon: Icons.group, label: 'Преподаватели', page: HomePage()),
    IconDataModel(icon: Icons.event_busy, label: 'Пропуски', page: Predmeti()),
    IconDataModel(icon: Icons.book, label: 'График', page: HomePage()),
    IconDataModel(icon: Icons.note, label: 'Записи', page: Predmeti()),
    IconDataModel(
        icon: Icons.bar_chart_rounded, label: 'Статистика', page: HomePage()),
    IconDataModel(
        icon: Icons.bar_chart_rounded, label: 'Статистика', page: HomePage()),
    IconDataModel(
        icon: Icons.bar_chart_rounded, label: 'Статистика', page: HomePage()),
  ];
  final List<SecondContainerDataModel> secondContainerDataList = [
    SecondContainerDataModel(
      icon: Icons.schedule,
      title: 'Расписание занятий',
      bottomText: 'У Вас нет занятий на сегодня',
      noDataText: 'Нет уроков',
    ),
    SecondContainerDataModel(
      icon: Icons.book_online,
      title: 'Домашнее задание',
      bottomText: 'У Вас нет домашней работы на сегодня',
      noDataText: 'Нет домашней работы',
    ),
    SecondContainerDataModel(
      icon: Icons.note_alt_rounded,
      title: 'Экзамены',
      bottomText: 'У Вас нет экзаменов на сегодня',
      noDataText: 'Нет экзаменов',
    ),
    SecondContainerDataModel(
      icon: Icons.calendar_month,
      title: 'События',
      bottomText: 'У Вас нет событий на сегодня',
      noDataText: 'Нет событий',
    ),
  ];
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Меню'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            icon: Icon(
              Icons.settings,
              color: Colors.lightBlue,
            ),
          ),
          IconButton(
            onPressed: () {
              AuthService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AuthPage()),
              );
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildFirstContainer(),
            buildSecondContainer(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadSecondContainerData();
  }

  void loadSecondContainerData() {
    // Сортировка списка по полю orderPreviewMenu
    secondContainerDataList.sort((item1, item2) {
      int index1 = SettingsModel.orderPreviewMenu.indexOf(item1.title);
      int index2 = SettingsModel.orderPreviewMenu.indexOf(item2.title);

      // Если элемент не найден в orderPreviewMenu, поместим его в конец списка
      if (index1 == -1) index1 = SettingsModel.orderPreviewMenu.length;
      if (index2 == -1) index2 = SettingsModel.orderPreviewMenu.length;

      return index1.compareTo(index2);
    });
  }

  Widget buildFirstContainer() {
    return Container(
      margin: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(
                255, 42, 18, 51), // Начальный цвет (верхний левый угол)
            Color.fromARGB(
                255, 20, 6, 20), // Конечный цвет (нижний правый угол)
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(2, 1),
          ),
        ],
      ),
      child: buildIconGrid(),
    );
  }

  Widget buildSecondContainer() {
    return Container(
      margin: EdgeInsets.only(right: 16, left: 16, top: 8, bottom: 16),
      width: double.infinity,
      child: SingleChildScrollView(
        child: ReorderableListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final item = secondContainerDataList.removeAt(oldIndex);
              secondContainerDataList.insert(newIndex, item);
              // Сохранение порядка элементов при изменении
              LocalSettingsService.saveOrderPreviewMenu(
                  secondContainerDataList.map((item) => item.title).toList());
            });
          },
          children: [
            for (var index = 0; index < secondContainerDataList.length; index++)
              ReorderableDelayedDragStartListener(
                key: Key('$index'), // Используем индекс в качестве ключа
                index: index,
                child: Container(
                  margin: EdgeInsets.only(top: 16),
                  child: buildAdditionalSummaryContainer(
                    secondContainerDataList[index],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildDaySummaryContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'Сводка дня:',
              style: TextStyle(
                fontSize: 18,
                shadows: [
                  Shadow(
                    color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                    offset: Offset(2, 2),
                    blurRadius: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
        buildDateButton(context),
      ],
    );
  }

  Widget buildDateButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _selectDate(context);
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Color.fromARGB(255, 41, 159, 255),
          ),
        ),
        elevation: 0, // Уровень поднятия при нажатии
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            size: 14,
            color: Color.fromARGB(255, 41, 159, 255),
          ),
          SizedBox(width: 8),
          Text(
            '${selectedDate.day.toString().padLeft(2, '0')}.${selectedDate.month.toString().padLeft(2, '0')}.${selectedDate.year}',
            style: TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      locale: const Locale('ru', 'RU'),
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Widget buildAdditionalSummaryContainer(SecondContainerDataModel dataModel) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(
                255, 20, 6, 20), // Конечный цвет (нижний правый угол)
            Color.fromARGB(
                255, 42, 18, 51), // Начальный цвет (верхний левый угол)
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(2, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildScheduleContainer(dataModel),
          buildNoLessonsContainer(dataModel),
          buildNoActivitiesContainer(dataModel),
        ],
      ),
    );
  }

  Widget buildScheduleContainer(SecondContainerDataModel dataModel) {
    return Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 35, 15, 43),
                    Color.fromARGB(64, 187, 134, 252),
                  ],
                ),
              ),
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.transparent,
                child: Icon(
                  dataModel.icon,
                  size: 15,
                  color: Color(0xffbb86fc),
                ),
              ),
            ),
            SizedBox(width: 8),
            Text(
              dataModel.title,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ));
  }

  Widget buildNoLessonsContainer(SecondContainerDataModel dataModel) {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        image: DecorationImage(
          alignment: Alignment.center,
          image: AssetImage("assets/Imgs/bgEmpty.png"),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(
            16.0), // Задайте значение, которое вам нравится
      ),
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              dataModel.icon,
              size: 30,
              color: Color(0xffbb86fc),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              dataModel.noDataText,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Color.fromARGB(255, 0, 0, 0).withOpacity(1),
                    offset: Offset(2, 2),
                    blurRadius: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNoActivitiesContainer(SecondContainerDataModel dataModel) {
    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: 8, right: 16, left: 16),
      child: Text(
        dataModel.bottomText,
        style: TextStyle(
            fontSize: 14, color: const Color.fromARGB(255, 122, 122, 122)),
      ),
    );
  }

  Widget buildIconGrid() {
    return GridView.builder(
      padding: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: iconDataList.length,
      itemBuilder: (context, index) {
        return SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(64, 187, 134, 252),
                      Color.fromARGB(255, 35, 15, 43),
                    ],
                  ),
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  child: IconButton(
                    padding: EdgeInsets.all(15),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => iconDataList[index].page,
                        ),
                      );
                    },
                    icon: Icon(
                      size: 30,
                      iconDataList[index].icon,
                      color: Color(0xffbb86fc),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                iconDataList[index].label,
                style: TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}

class IconDataModel {
  final IconData icon;
  final String label;
  final Widget page;

  IconDataModel({required this.icon, required this.label, required this.page});
}

class SecondContainerDataModel {
  final IconData icon;
  final String title;
  final String bottomText;
  final String noDataText;

  SecondContainerDataModel({
    required this.icon,
    required this.title,
    required this.bottomText,
    required this.noDataText,
  });
}
