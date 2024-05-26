// ignore_for_file: file_names, avoid_print

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stud_notes_tt/Model/Observer/userProfileObserverClass.dart';
import 'package:stud_notes_tt/Model/userProfileModel.dart';

class UserProfileDB {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static String? get userId => FirebaseAuth.instance.currentUser?.uid;
  static String get userPath => 'Users/$userId';
  static DocumentReference get userProfileDoc => _firestore.doc(userPath);

  static Stream<UserProfile?> _userProfileStream = userProfileStream();
  static UserProfile _lastUserProfile = UserProfile();
  static late StreamSubscription<UserProfile?> _subscription;

  static Future<String> updateUserProfile(UserProfile userProfile) async {
    try {
      await userProfileDoc.set({
        'Profile': {
          'tag': userProfile.tag,
          'institution': userProfile.institution,
          'course': userProfile.course,
          'group': userProfile.group,
        }
      });
      return 'Успешное обновление данных';
    } catch (e) {
      print('Error updating user profile: $e');
      return 'Неудачное обновление данных: $e';
    }
  }

  static Stream<UserProfile?> userProfileStream() {
    try {
      return userProfileDoc.snapshots().map((snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

          return UserProfile(
            tag: data?['Profile']['tag'] ?? '',
            institution: data?['Profile']['institution'] ?? '',
            course: data?['Profile']['course'] ?? '',
            group: data?['Profile']['group'] ?? '',
          );
        } else {
          return null;
        }
      });
    } catch (e) {
      print('Error creating user profile stream: $e');
      return Stream.value(null);
    }
  }

  static void Function(UserProfile?)? onUserProfileUpdated;

  static void listenToUserProfileStream() {
    _userProfileStream = userProfileStream();
    try {
      _subscription = _userProfileStream.listen((UserProfile? userProfile) {
        if (userProfile != null) {
          _lastUserProfile = userProfile;
          UserProfileObserver().notifyListeners(userProfile);
        }
      });
    } catch (e) {
      print('Error listening to user profile stream: $e');
    }
  }

  static void stopListeningToUserProfileStream() {
    _subscription.cancel();
  }

  static UserProfile getLastUserProfile() {
    return _lastUserProfile;
  }

  static void resetLastUserProfile() {
    _lastUserProfile = UserProfile();
  }
}
