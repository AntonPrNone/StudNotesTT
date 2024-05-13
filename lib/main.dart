import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:stud_notes_tt/Auth/authPage.dart';
import 'package:stud_notes_tt/DB/eventDB.dart';
import 'package:stud_notes_tt/DB/homeworkDB.dart';
import 'package:stud_notes_tt/DB/subjectDB.dart';
import 'package:stud_notes_tt/DB/timetableDB.dart';
import 'package:stud_notes_tt/DB/userProfileDB.dart';
import 'package:stud_notes_tt/Model/settingsModel.dart';
import 'package:stud_notes_tt/OtherPage/Homework/homeworkPage.dart';
import 'package:stud_notes_tt/ProfilePage.dart';
import 'package:stud_notes_tt/Settings/settingsPage.dart';
import 'DB/examDB.dart';
import 'DB/prepodsDB.dart';
import 'Home/homePage.dart';
import 'firebase_options.dart';
import 'LocalBD/localSettingsService.dart';
import 'precacheImages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (FirebaseAuth.instance.currentUser != null) {
    FirebaseAuth.instance.currentUser!.reload();
    if (FirebaseAuth.instance.currentUser!.emailVerified) {
      PrepodDB.listenToPrepodsStream();
      SubjectDB.listenToSubjectsStream();
      TimetableDB.listenToTimetableStream();
      HomeworkDB.listenToHomeworksStream();
      ExamDB.listenToExamsStream();
      EventDB.listenToEventsStream();
      UserProfileDB.listenToUserProfileStream();
    }
  }

  await LocalSettingsService.init();
  LocalSettingsService.loadSettings();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ImageSettings.precacheImages(context);
    WidgetsBinding.instance.addObserver(MyObserver(context));
    return MaterialApp(
      routes: {
        '/auth': (context) => const AuthPage(),
        '/home': (context) => const HomePage(),
        '/settings': (context) => SettingsPage(),
        '/profile': (context) => const ProfilePage(),
        '/homework': (context) => const HomeworkPage(),
      },
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ru', 'RU'),
      ],
      title: 'StudNotesTT',
      theme: buildCustomTheme(context),
      home: (FirebaseAuth.instance.currentUser == null ||
              !FirebaseAuth.instance.currentUser!.emailVerified)
          ? const AuthPage()
          : const HomePage(),
    );
  }
}

ThemeData buildCustomTheme(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context);

  const primaryColor = Color.fromARGB(255, 187, 134, 252);
  const floatingActionButtonColor = Colors.deepPurple;

  return ThemeData.dark().copyWith(
    dialogBackgroundColor: const Color.fromARGB(255, 10, 10, 10)
        .withOpacity(themeProvider.dialogOpacity ? 0.8 : 1),
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      onPrimary: Colors.white,
      onSurface: Colors.white,
    ),
    appBarTheme: AppBarTheme.of(context).copyWith(
      titleTextStyle: const TextStyle(
          fontFamily: 'Tektur', fontSize: 20, color: Colors.white),
      backgroundColor: const Color.fromARGB(255, 20, 20, 20),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: floatingActionButtonColor,
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  bool _dialogOpacity = SettingsModel.dialogOpacity;

  ThemeProvider() {
    _loadDialogOpacity();
  }

  bool get dialogOpacity => _dialogOpacity;

  set dialogOpacity(bool value) {
    _dialogOpacity = value;
    LocalSettingsService.saveDialogOpacity(value);
    notifyListeners();
  }

  void _loadDialogOpacity() async {
    _dialogOpacity = await LocalSettingsService.getDialogOpacity();
    notifyListeners();
  }
}
