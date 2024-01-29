// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:stud_notes_tt/Auth/authPage.dart';
import 'package:stud_notes_tt/Auth/authService.dart';
import 'package:stud_notes_tt/DB/prepodsDB.dart';
import '../Model/secondContainerDataModel.dart';
import '../LocalBD/localSettingsService.dart';
import '../Home/homePageElementsClass.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      body: Stack(
        children: [
          // Фоновое изображение
          Image.asset(
            'assets/Imgs/bg2.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color: const Color.fromARGB(122, 0, 0, 0),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                container1(),
                daySummaryContainer_c2(),
                container2(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    homePageElementsClass.loadSecondContainerData();
    PrepodDB.prepodsStream();
    PrepodDB.listenToPrepodsStream();
  }

  // -------------------------------------------------------------------------

  Widget container1() {
    return Container(
      margin: EdgeInsets.only(right: 16, left: 16, top: 16),
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
      child: menu_c1(),
    );
  }

  Widget container2() {
    return Container(
      margin: EdgeInsets.only(right: 16, left: 16, top: 0, bottom: 8),
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
              final item = homePageElementsClass.secondContainerDataList
                  .removeAt(oldIndex);
              homePageElementsClass.secondContainerDataList
                  .insert(newIndex, item);
              // Сохранение порядка элементов при изменении
              LocalSettingsService.saveOrderPreviewMenu(homePageElementsClass
                  .secondContainerDataList
                  .map((item) => item.title)
                  .toList());
            });
          },
          proxyDecorator:
              (Widget child, int index, Animation<double> animation) {
            return ReorderableDelayedDragStartListener(
              key: Key('$index'),
              index: index,
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  final double opacityValue = Curves.easeInOutCubic
                      .transform(1 - animation.value)
                      .clamp(0.8, 1.0);
                  final double scaleValue = Curves.easeInOutCubic
                      .transform(1 - animation.value)
                      .clamp(0.95, 1.0);

                  return Opacity(
                    opacity: opacityValue,
                    child: Transform.scale(
                      scale: scaleValue,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  child: child,
                ),
              ),
            );
          },
          children: [
            for (var index = 0;
                index < homePageElementsClass.secondContainerDataList.length;
                index++)
              Container(
                key: Key('$index'),
                margin: EdgeInsets.only(bottom: 16),
                child: summaryElContainer_c3(
                  homePageElementsClass.secondContainerDataList[index],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --------------------------------- C1 -------------------------------------

  Widget menu_c1() {
    return GridView.builder(
      padding: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: homePageElementsClass.iconDataList.length,
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
                          builder: (context) =>
                              homePageElementsClass.iconDataList[index].page,
                        ),
                      );
                    },
                    icon: Icon(
                      size: 30,
                      homePageElementsClass.iconDataList[index].icon,
                      color: Color(0xffbb86fc),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                homePageElementsClass.iconDataList[index].label,
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

  // --------------------------------- C2 -------------------------------------

  Widget daySummaryContainer_c2() {
    return Container(
      margin: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Сводка дня:',
            style: TextStyle(
              fontSize: 20,
              shadows: [
                Shadow(
                  color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                  offset: Offset(2, 2),
                  blurRadius: 1,
                ),
              ],
            ),
          ),
          dateButton(context),
        ],
      ),
    );
  }

  Widget dateButton(BuildContext context) {
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

  // --------------------------------- C3 -------------------------------------

  Widget summaryElContainer_c3(SecondContainerDataModel dataModel) {
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
          scheduleContainer(dataModel),
          noLessonsContainer(dataModel),
          noActivitiesContainer(dataModel),
        ],
      ),
    );
  }

  Widget scheduleContainer(SecondContainerDataModel dataModel) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
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
          ),
          Icon(
            Icons.drag_handle_rounded,
            color:
                Color.fromARGB(122, 255, 255, 255), // Цвет иконки перемещения
          ),
        ],
      ),
    );
  }

  Widget noLessonsContainer(SecondContainerDataModel dataModel) {
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

  Widget noActivitiesContainer(SecondContainerDataModel dataModel) {
    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: 8, right: 16, left: 16),
      child: Text(
        dataModel.bottomText,
        style: TextStyle(
            fontSize: 14, color: const Color.fromARGB(255, 122, 122, 122)),
      ),
    );
  }
}
