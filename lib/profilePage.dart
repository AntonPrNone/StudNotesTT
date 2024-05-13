// ignore_for_file: file_names, use_build_context_synchronously

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stud_notes_tt/DB/userProfileDB.dart';
import 'package:stud_notes_tt/Model/Observer/userProfileObserverClass.dart';
import 'package:stud_notes_tt/Model/settingsModel.dart';
import 'package:stud_notes_tt/Model/userProfileModel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfile? userProfile = UserProfileDB.getLastUserProfile();

  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  TextEditingController institutionController = TextEditingController();
  TextEditingController courseController = TextEditingController();
  TextEditingController groupController = TextEditingController();

  String? _updateProfileMessage;

  @override
  void initState() {
    super.initState();
    UserProfileObserver().addListener(_updateDataUserProfile);

    usernameController.text =
        FirebaseAuth.instance.currentUser!.displayName ?? '';
    tagController.text = userProfile!.tag;
    emailController.text = FirebaseAuth.instance.currentUser!.email!;
    institutionController.text = userProfile!.institution;
    courseController.text = userProfile!.course;
    groupController.text = userProfile!.group;
  }

  void _updateDataUserProfile(UserProfile? newData) {
    setState(() {
      userProfile = newData;

      FirebaseAuth.instance.currentUser!.reload();

      usernameController.text =
          FirebaseAuth.instance.currentUser!.displayName ?? 'Имя пользователя';
      tagController.text = userProfile!.tag;
      emailController.text = FirebaseAuth.instance.currentUser!.email!;
      institutionController.text = userProfile!.institution;
      courseController.text = userProfile!.course;
      groupController.text = userProfile!.group;
    });
  }

  @override
  void dispose() {
    UserProfileObserver().removeListener(_updateDataUserProfile);
    super.dispose();
  }

  Future<void> _updateUserProfile() async {
    String message = await UserProfileDB.updateUserProfile(UserProfile(
      tag: tagController.text,
      institution: institutionController.text,
      course: courseController.text,
      group: groupController.text,
    ));
    setState(() {
      _updateProfileMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        actions: [
          PopupMenuButton<String>(
            position: PopupMenuPosition.under,
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'changePassword',
                child: Text('Сменить пароль',
                    style: TextStyle(color: Colors.lightBlue)),
              ),
              const PopupMenuItem<String>(
                value: 'changeEmail',
                child: Text('Сменить эл. почту',
                    style: TextStyle(color: Colors.lightBlue)),
              ),
              const PopupMenuItem<String>(
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
            'assets/Imgs/bg1.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            color: const Color.fromARGB(122, 0, 0, 0),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                        backgroundImage:
                            const AssetImage('assets/Icons/User.png'),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextField(
                          controller: usernameController,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(color: Colors.blue),
                            labelText: 'Имя пользователя',
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                buildTextField('Почта', emailController,
                    icon: Icons.email, enabled: false),
                buildTextField('Тег пользователя', tagController,
                    icon: Icons.tag),
                buildTextField('Учебное заведение', institutionController,
                    icon: Icons.school),
                buildTextField('Курс/Класс', courseController,
                    isDigitsOnly: true, icon: Icons.class_),
                buildTextField('Группа', groupController, icon: Icons.group),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await _updateUserProfile();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: const Color.fromARGB(255, 20, 20, 20)
                            .withOpacity(0.5),
                        content: Text(
                          _updateProfileMessage ?? '',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ));
                    },
                    child: const Text(
                      'Сохранить',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(
    String labelText,
    TextEditingController controller, {
    bool isDigitsOnly = false,
    IconData? icon,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        dashPattern: const [7, 7],
        color: Colors.blue.withOpacity(0.25),
        strokeWidth: 2,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.blue),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: enabled,
                  keyboardType:
                      isDigitsOnly ? TextInputType.number : TextInputType.text,
                  inputFormatters: isDigitsOnly
                      ? <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          LengthLimitingTextInputFormatter(2),
                        ]
                      : null,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    suffixIcon: !enabled &&
                            FirebaseAuth.instance.currentUser!.emailVerified &&
                            SettingsModel.showCheckEmailProfile
                        ? Icon(
                            Icons.check_circle,
                            color: const Color.fromARGB(255, 0, 204, 7)
                                .withOpacity(0.75),
                          )
                        : null,
                    labelText: labelText,
                    labelStyle:
                        enabled ? const TextStyle(color: Colors.blue) : null,
                    hintStyle: const TextStyle(color: Colors.white),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
