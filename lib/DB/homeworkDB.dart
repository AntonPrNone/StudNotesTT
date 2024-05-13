// ignore_for_file: file_names, avoid_print
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stud_notes_tt/Model/homeworkModel.dart';
import 'package:stud_notes_tt/Model/Observer/homeworkObserverClass.dart';

class HomeworkDB {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static String? get userId => FirebaseAuth.instance.currentUser?.uid;
  static String get userPath => 'Users/$userId';
  static CollectionReference get homeworkCollection =>
      _firestore.collection('$userPath/Homeworks');

  static Stream<List<Homework>> _homeworksStream = homeworkStream();
  static List<Homework> _lastHomeworksList = [];
  static late StreamSubscription<List<Homework>> _subscription;

  static Future<List<Homework>> getHomeworks() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await homeworkCollection
          .orderBy('timestamp', descending: false)
          .get() as QuerySnapshot<Map<String, dynamic>>;

      if (snapshot.docs.isNotEmpty) {
        List<Homework> homeworks = snapshot.docs.map((doc) {
          return Homework(
            nameSubject: doc.data()['nameSubject'].toString(),
            description: doc.data()['description'].toString(),
            deadline: (doc.data()['deadline'] as Timestamp).toDate(),
            category: doc.data()['category'].toString(),
          );
        }).toList();
        return homeworks;
      }
      return [];
    } catch (e) {
      print('Error getting homeworks: $e');
      return [];
    }
  }

  static Future<Homework?> getHomeworkByNameAndDescription(
    String nameSubject,
    String description,
  ) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await homeworkCollection
          .where('nameSubject', isEqualTo: nameSubject)
          .where('description', isEqualTo: description)
          .limit(1)
          .get() as QuerySnapshot<Map<String, dynamic>>;

      if (snapshot.docs.isNotEmpty) {
        var doc = snapshot.docs.first;
        return Homework(
          nameSubject: doc.data()['nameSubject'].toString(),
          description: doc.data()['description'].toString(),
          deadline: (doc.data()['deadline'] as Timestamp).toDate(),
          category: doc.data()['category'].toString(),
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting homework by name and description: $e');
      return null;
    }
  }

  static Future<void> addHomework(Homework homework) async {
    try {
      await homeworkCollection.add({
        'nameSubject': homework.nameSubject,
        'description': homework.description,
        'deadline': homework.deadline,
        'category': homework.category,
        'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch
      });
    } catch (e) {
      print('Error adding homework: $e');
    }
  }

  static Future<void> deleteHomework(
      String nameSubject, String description) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await homeworkCollection
          .where('nameSubject', isEqualTo: nameSubject)
          .where('description', isEqualTo: description)
          .get() as QuerySnapshot<Map<String, dynamic>>;

      if (snapshot.docs.isNotEmpty) {
        await homeworkCollection.doc(snapshot.docs.first.id).delete();
      }
    } catch (e) {
      print('Error deleting homework: $e');
    }
  }

  static Future<void> editHomework(String oldNameSubject, String oldDescription,
      Homework newHomework) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await homeworkCollection
          .where('nameSubject', isEqualTo: oldNameSubject)
          .where('description', isEqualTo: oldDescription)
          .get() as QuerySnapshot<Map<String, dynamic>>;

      if (snapshot.docs.isNotEmpty) {
        await homeworkCollection.doc(snapshot.docs.first.id).update({
          'nameSubject': newHomework.nameSubject,
          'description': newHomework.description,
          'deadline': newHomework.deadline,
          'category': newHomework.category,
        });
      }
    } catch (e) {
      print('Error editing homework: $e');
    }
  }

  static Stream<List<Homework>> homeworkStream() {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> snapshotStream =
          homeworkCollection.orderBy('timestamp', descending: false).snapshots()
              as Stream<QuerySnapshot<Map<String, dynamic>>>;

      return snapshotStream.map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          List<Homework> homeworks = snapshot.docs.map((doc) {
            return Homework(
              nameSubject: doc.data()['nameSubject'].toString(),
              description: doc.data()['description'].toString(),
              deadline: (doc.data()['deadline'] as Timestamp).toDate(),
              category: doc.data()['category'].toString(),
            );
          }).toList();
          return homeworks;
        } else {
          return <Homework>[];
        }
      }).asBroadcastStream();
    } catch (e) {
      print('Error creating homeworks stream: $e');
      return Stream.value([]);
    }
  }

  static void Function(List<Homework>)? onDataUpdated;

  static void listenToHomeworksStream() {
    _homeworksStream = homeworkStream();
    try {
      _subscription = _homeworksStream.listen((List<Homework> snapshot) {
        _lastHomeworksList = snapshot;
        HomeworkObserver().notifyListeners(snapshot);
      });
    } catch (e) {
      print('Error listening to homeworks stream: $e');
    }
  }

  static void stopListeningToHomeworksStream() {
    _subscription.cancel();
  }

  static List<Homework> getLastHomeworksList() {
    return _lastHomeworksList;
  }

  static List<String> getHomeworksDescriptions() {
    return _lastHomeworksList.map((homework) => homework.description).toList();
  }

  static Future<void> deleteExpiredHomeworks() async {
    try {
      final currentTime = DateTime.now();
      final expiredHomeworksQuery = await homeworkCollection
          .where('deadline', isLessThan: currentTime)
          .get();

      for (final doc in expiredHomeworksQuery.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error deleting expired homeworks: $e');
    }
  }
}
