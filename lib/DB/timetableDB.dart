// ignore_for_file: file_names, avoid_print

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stud_notes_tt/Model/Observer/timetableObserverClass.dart';
import 'package:stud_notes_tt/Model/timetableItemModel.dart';

class TimetableDB {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static String? get userId => FirebaseAuth.instance.currentUser?.uid;
  static String get userPath => 'Users/$userId';
  static CollectionReference get timetableCollection =>
      _firestore.collection('$userPath/Timetable');

  static Stream<List<TimetableItem>> _timetableStream = timetableStream();
  static List<TimetableItem> _lastTimetableList = [];
  static late StreamSubscription<List<TimetableItem>> _subscription;

  static Future<List<TimetableItem>> getTimetableItems() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await timetableCollection
          .orderBy('startTimeMinutes', descending: false)
          .get() as QuerySnapshot<Map<String, dynamic>>;
      if (snapshot.docs.isNotEmpty) {
        List<TimetableItem> timetableItems = snapshot.docs.map((doc) {
          return TimetableItem(
            dayOfWeek: doc.data()['dayOfWeek'],
            subjectName: doc.data()['subjectName'],
            iconPath: doc.data()['iconPath'],
            startTime: _minutesToTimeOfDay(doc.data()['startTimeMinutes']),
            endTime: _minutesToTimeOfDay(doc.data()['endTimeMinutes']),
            room: doc.data()['room'],
            teacher: doc.data()['teacher'],
            note: doc.data()['note'],
          );
        }).toList();
        return timetableItems;
      }
      return [];
    } catch (e) {
      print('Error getting timetable items: $e');
      return [];
    }
  }

  static Future<void> addTimetableItem(TimetableItem item) async {
    try {
      await timetableCollection.add({
        'dayOfWeek': item.dayOfWeek,
        'subjectName': item.subjectName,
        'iconPath': item.iconPath,
        'startTimeMinutes': _timeOfDayToMinutes(item.startTime),
        'endTimeMinutes': _timeOfDayToMinutes(item.endTime),
        'room': item.room,
        'teacher': item.teacher,
        'note': item.note,
        'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch,
      });
    } catch (e) {
      print('Error adding timetable item: $e');
    }
  }

  static Future<void> deleteTimetableItem(String subjectName, String dayOfWeek,
      TimeOfDay startTime, TimeOfDay endTime) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await timetableCollection
          .where('subjectName', isEqualTo: subjectName)
          .where('dayOfWeek', isEqualTo: dayOfWeek)
          .where('startTimeMinutes', isEqualTo: _timeOfDayToMinutes(startTime))
          .where('endTimeMinutes', isEqualTo: _timeOfDayToMinutes(endTime))
          .get() as QuerySnapshot<Map<String, dynamic>>;
      if (snapshot.docs.isNotEmpty) {
        await timetableCollection.doc(snapshot.docs.first.id).delete();
      }
    } catch (e) {
      print('Error deleting timetable item: $e');
    }
  }

  static Future<void> editTimetableItem(
      String oldSubjectName,
      String oldDayOfWeek,
      TimeOfDay oldStartTime,
      TimeOfDay oldEndTime,
      TimetableItem newItem) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await timetableCollection
          .where('subjectName', isEqualTo: oldSubjectName)
          .where('dayOfWeek', isEqualTo: oldDayOfWeek)
          .where('startTimeMinutes',
              isEqualTo: _timeOfDayToMinutes(oldStartTime))
          .where('endTimeMinutes', isEqualTo: _timeOfDayToMinutes(oldEndTime))
          .get() as QuerySnapshot<Map<String, dynamic>>;
      if (snapshot.docs.isNotEmpty) {
        await timetableCollection.doc(snapshot.docs.first.id).update({
          'dayOfWeek': newItem.dayOfWeek,
          'subjectName': newItem.subjectName,
          'iconPath': newItem.iconPath,
          'startTimeMinutes': _timeOfDayToMinutes(newItem.startTime),
          'endTimeMinutes': _timeOfDayToMinutes(newItem.endTime),
          'room': newItem.room,
          'teacher': newItem.teacher,
          'note': newItem.note,
        });
      }
    } catch (e) {
      print('Error editing timetable item: $e');
    }
  }

  static Stream<List<TimetableItem>> timetableStream() {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> snapshotStream =
          timetableCollection
              .orderBy('startTimeMinutes', descending: false)
              .snapshots() as Stream<QuerySnapshot<Map<String, dynamic>>>;
      return snapshotStream.map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          List<TimetableItem> timetableItems = snapshot.docs.map((doc) {
            return TimetableItem(
              dayOfWeek: doc.data()['dayOfWeek'],
              subjectName: doc.data()['subjectName'],
              iconPath: doc.data()['iconPath'],
              startTime: _minutesToTimeOfDay(doc.data()['startTimeMinutes']),
              endTime: _minutesToTimeOfDay(doc.data()['endTimeMinutes']),
              room: doc.data()['room'],
              teacher: doc.data()['teacher'],
              note: doc.data()['note'],
            );
          }).toList();
          return timetableItems;
        } else {
          return <TimetableItem>[];
        }
      }).asBroadcastStream();
    } catch (e) {
      print('Error creating timetable stream: $e');
      return Stream.value([]);
    }
  }

  static void Function(List<TimetableItem>)? onDataUpdated;

  static void listenToTimetableStream() {
    _timetableStream = timetableStream();
    try {
      _subscription = _timetableStream.listen((List<TimetableItem> snapshot) {
        _lastTimetableList = snapshot;
        TimetableObserver().notifyListeners(snapshot);
      });
    } catch (e) {
      print('Error listening to timetable stream: $e');
    }
  }

  static void stopListeningToTimetableStream() {
    _subscription.cancel();
  }

  static List<TimetableItem> getLastTimetableList() {
    return _lastTimetableList;
  }

  static int _timeOfDayToMinutes(TimeOfDay timeOfDay) {
    return timeOfDay.hour * 60 + timeOfDay.minute;
  }

  static TimeOfDay _minutesToTimeOfDay(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return TimeOfDay(hour: hours, minute: remainingMinutes);
  }
}
