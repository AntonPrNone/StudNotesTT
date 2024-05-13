// ignore_for_file: file_names, avoid_print

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stud_notes_tt/Model/Observer/eventObserverClass.dart';
import 'package:stud_notes_tt/Model/eventModel.dart';
import 'package:stud_notes_tt/blanks.dart';

class EventDB {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static String? get userId => FirebaseAuth.instance.currentUser?.uid;
  static String get userPath => 'Users/$userId';
  static CollectionReference get eventCollection =>
      _firestore.collection('$userPath/Events');

  static Stream<List<Event>> _eventsStream = eventStream();
  static List<Event> _lastEventsList = [];
  static late StreamSubscription<List<Event>> _subscription;

  static Future<List<Event>> getEvents() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await eventCollection
          .orderBy('startTime', descending: false)
          .get() as QuerySnapshot<Map<String, dynamic>>;

      if (snapshot.docs.isNotEmpty) {
        List<Event> events = snapshot.docs.map((doc) {
          return Event(
            name: doc.data()['name'].toString(),
            category: doc.data()['category'].toString(),
            date: (doc.data()['date'] as Timestamp).toDate(),
            startTime: convertTimestampToTimeOfDay(doc.data()['startTime']),
            endTime: convertTimestampToTimeOfDay(doc.data()['endTime']),
            place: doc.data()['place'].toString(),
            description: doc.data()['description'].toString(),
          );
        }).toList();
        return events;
      }
      return [];
    } catch (e) {
      print('Error getting events: $e');
      return [];
    }
  }

  static Future<Event?> getEventByNameDateAndTime(
    String name,
    DateTime date,
    TimeOfDay startTime,
    TimeOfDay endTime,
  ) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await eventCollection
          .where('name', isEqualTo: name)
          .where('date', isEqualTo: date)
          .where('startTime',
              isEqualTo: convertTimeOfDayToDateTime(DateTime(2000), startTime))
          .where('endTime',
              isEqualTo: convertTimeOfDayToDateTime(DateTime(2000), endTime))
          .limit(1)
          .get() as QuerySnapshot<Map<String, dynamic>>;

      if (snapshot.docs.isNotEmpty) {
        var doc = snapshot.docs.first;
        return Event(
          name: doc.data()['name'].toString(),
          category: doc.data()['category'].toString(),
          date: (doc.data()['date'] as Timestamp).toDate(),
          startTime: convertTimestampToTimeOfDay(doc.data()['startTime']),
          endTime: convertTimestampToTimeOfDay(doc.data()['endTime']),
          place: doc.data()['place'].toString(),
          description: doc.data()['description'].toString(),
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting event by name, date, and time: $e');
      return null;
    }
  }

  static Future<void> addEvent(Event event) async {
    try {
      await eventCollection.add({
        'name': event.name,
        'category': event.category,
        'date': event.date,
        'startTime':
            convertTimeOfDayToDateTime(DateTime(2000), event.startTime),
        'endTime': convertTimeOfDayToDateTime(DateTime(2000), event.endTime),
        'place': event.place,
        'description': event.description,
        'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch
      });
    } catch (e) {
      print('Error adding event: $e');
    }
  }

  static Future<void> editEvent(
    Event oldEvent,
    Event newEvent,
  ) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await eventCollection
          .where('name', isEqualTo: oldEvent.name)
          .where('date', isEqualTo: oldEvent.date)
          .where('startTime',
              isEqualTo: convertTimeOfDayToDateTime(
                  DateTime(2000), oldEvent.startTime))
          .where('endTime',
              isEqualTo:
                  convertTimeOfDayToDateTime(DateTime(2000), oldEvent.endTime))
          .get() as QuerySnapshot<Map<String, dynamic>>;

      if (snapshot.docs.isNotEmpty) {
        await eventCollection.doc(snapshot.docs.first.id).update({
          'name': newEvent.name,
          'category': newEvent.category,
          'date': newEvent.date,
          'startTime':
              convertTimeOfDayToDateTime(DateTime(2000), newEvent.startTime),
          'endTime':
              convertTimeOfDayToDateTime(DateTime(2000), newEvent.endTime),
          'place': newEvent.place,
          'description': newEvent.description,
        });
      }
    } catch (e) {
      print('Error editing event: $e');
    }
  }

  static Future<void> deleteEvent(
    String name,
    DateTime date,
    TimeOfDay startTime,
    TimeOfDay endTime,
  ) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await eventCollection
          .where('name', isEqualTo: name)
          .where('date', isEqualTo: date)
          .where('startTime',
              isEqualTo: convertTimeOfDayToDateTime(DateTime(2000), startTime))
          .where('endTime',
              isEqualTo: convertTimeOfDayToDateTime(DateTime(2000), endTime))
          .get() as QuerySnapshot<Map<String, dynamic>>;

      if (snapshot.docs.isNotEmpty) {
        await eventCollection.doc(snapshot.docs.first.id).delete();
      }
    } catch (e) {
      print('Error deleting event: $e');
    }
  }

  static Stream<List<Event>> eventStream() {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> snapshotStream =
          eventCollection.orderBy('startTime', descending: false).snapshots()
              as Stream<QuerySnapshot<Map<String, dynamic>>>;

      return snapshotStream.map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          List<Event> events = snapshot.docs.map((doc) {
            return Event(
              name: doc.data()['name'].toString(),
              category: doc.data()['category'].toString(),
              date: (doc.data()['date'] as Timestamp).toDate(),
              startTime: convertTimestampToTimeOfDay(doc.data()['startTime']),
              endTime: convertTimestampToTimeOfDay(doc.data()['endTime']),
              place: doc.data()['place'].toString(),
              description: doc.data()['description'].toString(),
            );
          }).toList();
          return events;
        } else {
          return <Event>[];
        }
      }).asBroadcastStream();
    } catch (e) {
      print('Error creating events stream: $e');
      return Stream.value([]);
    }
  }

  static void Function(List<Event>)? onDataUpdated;

  static void listenToEventsStream() {
    _eventsStream = eventStream();
    try {
      _subscription = _eventsStream.listen((List<Event> snapshot) {
        _lastEventsList = snapshot;
        EventObserver().notifyListeners(snapshot);
      });
    } catch (e) {
      print('Error listening to events stream: $e');
    }
  }

  static void stopListeningToEventsStream() {
    _subscription.cancel();
  }

  static List<Event> getLastEventsList() {
    return _lastEventsList;
  }

  static List<String> getEventsDescriptions() {
    return _lastEventsList.map((event) => event.description).toList();
  }

  static Future<void> deleteExpiredEvents() async {
    try {
      final currentTime = DateTime.now();
      final expiredEventsQuery =
          await eventCollection.where('date', isLessThan: currentTime).get();

      for (final doc in expiredEventsQuery.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error deleting expired events: $e');
    }
  }
}
