// ignore_for_file: file_names, avoid_print
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stud_notes_tt/Model/prepodModel.dart';
import '../Model/Observer/prepodsObserverClass.dart';

class PrepodDB {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static String? get userId => FirebaseAuth.instance.currentUser?.uid;
  static String get userPath => 'Users/$userId';
  static CollectionReference get prepodsCollection =>
      _firestore.collection('$userPath/Prepods');

  static Stream<List<Prepod>> _prepodsStream = prepodsStream();
  static List<Prepod> _lastPrepodsList = [];
  static late StreamSubscription<List<Prepod>> _subscription;

  static Future<List<Prepod>> getPrepods() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await prepodsCollection
          .orderBy('timestamp', descending: false)
          .get() as QuerySnapshot<Map<String, dynamic>>;

      if (snapshot.docs.isNotEmpty) {
        List<Prepod> prepods = snapshot.docs.map((doc) {
          return Prepod(
            name: doc.data()['name'].toString(),
            note: doc.data()['note'].toString(),
          );
        }).toList();
        return prepods;
      }
      return [];
    } catch (e) {
      print('Error getting prepods: $e');
      return [];
    }
  }

  static Future<void> addPrepod(Prepod prepod) async {
    try {
      await prepodsCollection.add({
        'name': prepod.name,
        'note': prepod.note,
        'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch
      });
    } catch (e) {
      print('Error adding prepod: $e');
    }
  }

  static Future<void> deletePrepod(String prepodName) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await prepodsCollection
          .where('name', isEqualTo: prepodName)
          .get() as QuerySnapshot<Map<String, dynamic>>;

      if (snapshot.docs.isNotEmpty) {
        await prepodsCollection.doc(snapshot.docs.first.id).delete();
      }
    } catch (e) {
      print('Error deleting prepod: $e');
    }
  }

  static Future<void> editPrepod(
      String oldPrepodName, String newPrepodName, String newPrepodNote) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await prepodsCollection
          .where('name', isEqualTo: oldPrepodName)
          .get() as QuerySnapshot<Map<String, dynamic>>;

      if (snapshot.docs.isNotEmpty) {
        await prepodsCollection.doc(snapshot.docs.first.id).update({
          'name': newPrepodName,
          'note': newPrepodNote,
        });
      }
    } catch (e) {
      print('Error editing prepod: $e');
    }
  }

  static Stream<List<Prepod>> prepodsStream() {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> snapshotStream =
          prepodsCollection.orderBy('timestamp', descending: false).snapshots()
              as Stream<QuerySnapshot<Map<String, dynamic>>>;

      return snapshotStream.map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          List<Prepod> prepods = snapshot.docs.map((doc) {
            return Prepod(
              name: doc.data()['name'].toString(),
              note: doc.data()['note'].toString(),
            );
          }).toList();
          return prepods;
        } else {
          return <Prepod>[]; // Возвращаем пустой List<Prepod>
        }
      }).asBroadcastStream();
    } catch (e) {
      print('Error creating prepods stream: $e');
      return Stream.value([]);
    }
  }

  static void Function(List<Prepod>)? onDataUpdated;

  static void listenToPrepodsStream() {
    _prepodsStream = prepodsStream();
    try {
      _subscription = _prepodsStream.listen((List<Prepod> snapshot) {
        _lastPrepodsList = snapshot;
        PrepodsObserver().notifyListeners(snapshot);
      });
    } catch (e) {
      print('Error listening to prepods stream: $e');
    }
  }

  static void stopListeningToPrepodsStream() {
    _subscription.cancel();
  }

  static List<Prepod> getLastPrepodsList() {
    return _lastPrepodsList;
  }

  static List<String> getPrepodNames() {
    return _lastPrepodsList.map((prepod) => prepod.name).toList();
  }
}

// Класс для представления преподавателя
