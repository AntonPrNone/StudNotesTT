// ignore_for_file: file_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PrepodDB {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static String? get userId => FirebaseAuth.instance.currentUser?.uid;
  static String get userSettingsPath => 'Users/$userId';
  static CollectionReference get prepodsCollection =>
      _firestore.collection('$userSettingsPath/Prepods');
  static final Stream<List<String>> _prepodsStream = prepodsStream();

  static List<String> _lastPrepodsList = [];

  static Future<List<String>> getPrepods() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await prepodsCollection
          .orderBy('timestamp', descending: false)
          .get() as QuerySnapshot<Map<String, dynamic>>;

      if (snapshot.docs.isNotEmpty) {
        List<String> prepods =
            snapshot.docs.map((doc) => doc.data()['name'].toString()).toList();
        return prepods;
      }

      return [];
    } catch (e) {
      print('Error getting prepods: $e');
      return [];
    }
  }

  static Future<void> addPrepod(String prepodName) async {
    try {
      await prepodsCollection.add({
        'name': prepodName,
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
      String oldPrepodName, String newPrepodName) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await prepodsCollection
          .where('name', isEqualTo: oldPrepodName)
          .get() as QuerySnapshot<Map<String, dynamic>>;

      if (snapshot.docs.isNotEmpty) {
        await prepodsCollection
            .doc(snapshot.docs.first.id)
            .update({'name': newPrepodName});
      }
    } catch (e) {
      print('Error editing prepod: $e');
    }
  }

  static Stream<List<String>> prepodsStream() {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> snapshotStream =
          prepodsCollection.orderBy('timestamp', descending: false).snapshots()
              as Stream<QuerySnapshot<Map<String, dynamic>>>;

      return snapshotStream.map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          List<String> prepods = snapshot.docs
              .map((doc) => (doc.data())['name'].toString())
              .toList();
          return prepods;
        } else {
          return <String>[]; // Возвращаем пустой List<String>
        }
      }).asBroadcastStream();
    } catch (e) {
      print('Error creating prepods stream: $e');
      return Stream.value([]);
    }
  }

  static void listenToPrepodsStream() {
    try {
      _prepodsStream.listen((List<String> snapshot) {
        _lastPrepodsList = snapshot;
      });
    } catch (e) {
      print('Error listening to prepods stream: $e');
    }
  }

  static List<String> getLastPrepodsList() {
    return _lastPrepodsList;
  }
}
