// ignore_for_file: file_names, avoid_print
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stud_notes_tt/subjectObserverClass.dart';

class SubjectDB {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static String? get userId => FirebaseAuth.instance.currentUser?.uid;
  static String get userPath => 'Users/$userId';
  static CollectionReference get subjectsCollection =>
      _firestore.collection('$userPath/Subjects');

  static Stream<List<Subject>> _subjectsStream = subjectsStream();
  static List<Subject> _lastSubjectsList = [];
  static late StreamSubscription<List<Subject>> _subscription;

  static Future<List<Subject>> getSubjects() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await subjectsCollection
          .orderBy('timestamp', descending: false)
          .get() as QuerySnapshot<Map<String, dynamic>>;

      if (snapshot.docs.isNotEmpty) {
        List<Subject> subjects = snapshot.docs.map((doc) {
          return Subject(
            name: doc.data()['name'].toString(),
            iconPath:
                doc.data()['iconPath'].toString(), // Получаем путь к иконке
            room: doc.data()['room'].toString(),
            teacher: doc.data()['teacher'].toString(),
            note: doc.data()['note'].toString(),
          );
        }).toList();
        return subjects;
      }
      return [];
    } catch (e) {
      print('Error getting subjects: $e');
      return [];
    }
  }

  static Future<void> addSubject(Subject subject) async {
    try {
      await subjectsCollection.add({
        'name': subject.name,
        'iconPath': subject.iconPath, // Сохраняем путь к иконке
        'room': subject.room,
        'teacher': subject.teacher,
        'note': subject.note,
        'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch
      });
    } catch (e) {
      print('Error adding subject: $e');
    }
  }

  static Future<void> deleteSubject(String subjectName) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await subjectsCollection
          .where('name', isEqualTo: subjectName)
          .get() as QuerySnapshot<Map<String, dynamic>>;

      if (snapshot.docs.isNotEmpty) {
        await subjectsCollection.doc(snapshot.docs.first.id).delete();
      }
    } catch (e) {
      print('Error deleting subject: $e');
    }
  }

  static Future<void> editSubject(
      String oldSubjectName, Subject newSubject) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await subjectsCollection
          .where('name', isEqualTo: oldSubjectName)
          .get() as QuerySnapshot<Map<String, dynamic>>;

      if (snapshot.docs.isNotEmpty) {
        await subjectsCollection.doc(snapshot.docs.first.id).update({
          'name': newSubject.name,
          'iconPath': newSubject.iconPath, // Обновляем путь к иконке
          'room': newSubject.room,
          'teacher': newSubject.teacher,
          'note': newSubject.note,
        });
      }
    } catch (e) {
      print('Error editing subject: $e');
    }
  }

  static Stream<List<Subject>> subjectsStream() {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> snapshotStream =
          subjectsCollection.orderBy('timestamp', descending: false).snapshots()
              as Stream<QuerySnapshot<Map<String, dynamic>>>;

      return snapshotStream.map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          List<Subject> subjects = snapshot.docs.map((doc) {
            return Subject(
              name: doc.data()['name'].toString(),
              iconPath:
                  doc.data()['iconPath'].toString(), // Получаем путь к иконке
              room: doc.data()['room'].toString(),
              teacher: doc.data()['teacher'].toString(),
              note: doc.data()['note'].toString(),
            );
          }).toList();
          return subjects;
        } else {
          return <Subject>[]; // Возвращаем пустой List<Subject>
        }
      }).asBroadcastStream();
    } catch (e) {
      print('Error creating subjects stream: $e');
      return Stream.value([]);
    }
  }

  static void Function(List<Subject>)? onDataUpdated;

  static void listenToSubjectsStream() {
    _subjectsStream = subjectsStream();
    try {
      _subscription = _subjectsStream.listen((List<Subject> snapshot) {
        _lastSubjectsList = snapshot;
        SubjectObserver().notifyListeners(snapshot);
      });
    } catch (e) {
      print('Error listening to subjects stream: $e');
    }
  }

  static void stopListeningToSubjectsStream() {
    _subscription.cancel();
  }

  static List<Subject> getLastSubjectsList() {
    return _lastSubjectsList;
  }
}

// Класс для представления дисциплины
class Subject {
  final String name;
  final String iconPath;
  final String room;
  final String teacher;
  final String note;

  Subject({
    required this.name,
    required this.iconPath,
    required this.room,
    required this.teacher,
    required this.note,
  });
}
