// ignore_for_file: file_names, avoid_print

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stud_notes_tt/Model/examModel.dart';
import 'package:stud_notes_tt/Model/Observer/examObserverClass.dart';
import 'package:stud_notes_tt/blanks.dart';

class ExamDB {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static String? get userId => FirebaseAuth.instance.currentUser?.uid;
  static String get userPath => 'Users/$userId';
  static CollectionReference get examCollection =>
      _firestore.collection('$userPath/Exams');

  static Stream<List<Exam>> _examsStream = examStream();
  static List<Exam> _lastExamsList = [];
  static late StreamSubscription<List<Exam>> _subscription;

  static Future<List<Exam>> getExams() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await examCollection
          .orderBy('startTime', descending: false)
          .get() as QuerySnapshot<Map<String, dynamic>>;

      if (snapshot.docs.isNotEmpty) {
        List<Exam> exams = snapshot.docs.map((doc) {
          return Exam(
            nameSubject: doc.data()['nameSubject'].toString(),
            examCategory: doc.data()['examCategory'].toString(),
            date: (doc.data()['date'] as Timestamp).toDate(),
            startTime: convertTimestampToTimeOfDay(doc.data()['startTime']),
            endTime: convertTimestampToTimeOfDay(doc.data()['endTime']),
            room: doc.data()['room'].toString(),
            description: doc.data()['description'].toString(),
          );
        }).toList();
        return exams;
      }
      return [];
    } catch (e) {
      print('Error getting exams: $e');
      return [];
    }
  }

  static Future<Exam?> getExamByNameDateAndTime(
    String nameSubject,
    DateTime date,
    TimeOfDay startTime,
    TimeOfDay endTime,
  ) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await examCollection
          .where('nameSubject', isEqualTo: nameSubject)
          .where('date', isEqualTo: date)
          .where('startTime',
              isEqualTo: convertTimeOfDayToDateTime(date, startTime))
          .where('endTime',
              isEqualTo: convertTimeOfDayToDateTime(date, endTime))
          .limit(1)
          .get() as QuerySnapshot<Map<String, dynamic>>;

      if (snapshot.docs.isNotEmpty) {
        var doc = snapshot.docs.first;
        return Exam(
          nameSubject: doc.data()['nameSubject'].toString(),
          examCategory: doc.data()['examCategory'].toString(),
          date: (doc.data()['date'] as Timestamp).toDate(),
          startTime: convertTimestampToTimeOfDay(doc.data()['startTime']),
          endTime: convertTimestampToTimeOfDay(doc.data()['endTime']),
          room: doc.data()['room'].toString(),
          description: doc.data()['description'].toString(),
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting exam by name, date, and time: $e');
      return null;
    }
  }

  static Future<void> addExam(Exam exam) async {
    try {
      await examCollection.add({
        'nameSubject': exam.nameSubject,
        'examCategory': exam.examCategory,
        'date': exam.date,
        'startTime': convertTimeOfDayToDateTime(DateTime(2000), exam.startTime),
        'endTime': convertTimeOfDayToDateTime(DateTime(2000), exam.endTime),
        'room': exam.room,
        'description': exam.description,
        'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch
      });
    } catch (e) {
      print('Error adding exam: $e');
    }
  }

  static Future<void> editExam(
    Exam oldExam,
    Exam newExam,
  ) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await examCollection
          .where('nameSubject', isEqualTo: oldExam.nameSubject)
          .where('date', isEqualTo: oldExam.date)
          .where('startTime',
              isEqualTo:
                  convertTimeOfDayToDateTime(DateTime(2000), oldExam.startTime))
          .where('endTime',
              isEqualTo:
                  convertTimeOfDayToDateTime(DateTime(2000), oldExam.endTime))
          .get() as QuerySnapshot<Map<String, dynamic>>;

      if (snapshot.docs.isNotEmpty) {
        await examCollection.doc(snapshot.docs.first.id).update({
          'nameSubject': newExam.nameSubject,
          'examCategory': newExam.examCategory,
          'date': newExam.date,
          'startTime':
              convertTimeOfDayToDateTime(DateTime(2000), newExam.startTime),
          'endTime':
              convertTimeOfDayToDateTime(DateTime(2000), newExam.endTime),
          'room': newExam.room,
          'description': newExam.description,
        });
      }
    } catch (e) {
      print('Error editing exam: $e');
    }
  }

  static Future<void> deleteExam(
    String nameSubject,
    DateTime date,
    TimeOfDay startTime,
    TimeOfDay endTime,
  ) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await examCollection
          .where('nameSubject', isEqualTo: nameSubject)
          .where('date', isEqualTo: date)
          .where('startTime',
              isEqualTo: convertTimeOfDayToDateTime(DateTime(2000), startTime))
          .where('endTime',
              isEqualTo: convertTimeOfDayToDateTime(DateTime(2000), endTime))
          .get() as QuerySnapshot<Map<String, dynamic>>;

      if (snapshot.docs.isNotEmpty) {
        await examCollection.doc(snapshot.docs.first.id).delete();
      }
    } catch (e) {
      print('Error deleting exam: $e');
    }
  }

  static Stream<List<Exam>> examStream() {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> snapshotStream =
          examCollection.orderBy('startTime', descending: false).snapshots()
              as Stream<QuerySnapshot<Map<String, dynamic>>>;

      return snapshotStream.map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          List<Exam> exams = snapshot.docs.map((doc) {
            return Exam(
              nameSubject: doc.data()['nameSubject'].toString(),
              examCategory: doc.data()['examCategory'].toString(),
              date: (doc.data()['date'] as Timestamp).toDate(),
              startTime: convertTimestampToTimeOfDay(doc.data()['startTime']),
              endTime: convertTimestampToTimeOfDay(doc.data()['endTime']),
              room: doc.data()['room'].toString(),
              description: doc.data()['description'].toString(),
            );
          }).toList();
          return exams;
        } else {
          return <Exam>[];
        }
      }).asBroadcastStream();
    } catch (e) {
      print('Error creating exams stream: $e');
      return Stream.value([]);
    }
  }

  static void Function(List<Exam>)? onDataUpdated;

  static void listenToExamsStream() {
    _examsStream = examStream();
    try {
      _subscription = _examsStream.listen((List<Exam> snapshot) {
        _lastExamsList = snapshot;
        ExamObserver().notifyListeners(snapshot);
      });
    } catch (e) {
      print('Error listening to exams stream: $e');
    }
  }

  static void stopListeningToExamsStream() {
    _subscription.cancel();
  }

  static List<Exam> getLastExamsList() {
    return _lastExamsList;
  }

  static List<String> getExamsDescriptions() {
    return _lastExamsList.map((exam) => exam.description).toList();
  }

  static Future<void> deleteExpiredExams() async {
    try {
      final currentTime = DateTime.now();
      final expiredExamsQuery =
          await examCollection.where('date', isLessThan: currentTime).get();
      for (final doc in expiredExamsQuery.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error deleting expired exams: $e');
    }
  }
}
