// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = 'Имя пользователя';
  String tag = '@тег_пользователя';
  String email = 'email@example.com';
  String institution = 'Название учебного заведения';
  String course = '4';
  String group = '421';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль'),
        actions: [
          PopupMenuButton<String>(
            position: PopupMenuPosition.under,
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'changePassword',
                child: Text('Сменить пароль',
                    style: TextStyle(color: Colors.lightBlue)),
              ),
              PopupMenuItem<String>(
                value: 'changeEmail',
                child: Text('Сменить эл. почту',
                    style: TextStyle(color: Colors.lightBlue)),
              ),
              PopupMenuItem<String>(
                value: 'deleteAccount',
                child: Text(
                  'Удалить аккаунт',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
            onSelected: (String value) {
              // Обработка выбора в меню
              if (value == 'changePassword') {
                // Обработка нажатия на "Сменить пароль"
              } else if (value == 'changeEmail') {
                // Обработка нажатия на "Сменить эл. почту"
              } else if (value == 'deleteAccount') {
                // Обработка нажатия на "Удалить аккаунт"
              }
            },
          ),
        ],
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
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    // Обработка нажатия на аватарку
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.5),
                        radius: 40,
                        backgroundImage: AssetImage('assets/Icons/User.png'),
                      ),
                      SizedBox(width: 20),
                      Text(
                        username,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                buildProfileItem(tag),
                buildProfileItem(email),
                buildProfileItem('Учебное заведение: $institution'),
                buildProfileItem('Курс: $course'),
                buildProfileItem('Группа: $group'),
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Присоединиться к группе'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileItem(String text) {
    return InkWell(
      onTap: () {
        // Обработка нажатия на пункт профиля
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
