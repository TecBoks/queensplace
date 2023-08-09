import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bequeen/auth/repository/auth_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class AuthBloc implements Bloc {
  final _authRepository = AuthRepository();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  final _loadingSubject = BehaviorSubject<bool>();
  Stream<bool> get loadingStream => _loadingSubject.stream;
  void setIsLoading(bool loading) => _loadingSubject.add(loading);

  final _userSubject = BehaviorSubject<User>();
  Stream<User> get userStream => _userSubject.stream;
  void setUser(User loading) => _userSubject.add(loading);

  Future initialise(
      context, userAuth, storage, Function showLocalNotification) async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      _fcm.requestPermission();
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        // app in foreground
        showLocalNotification(notification.title, notification.body);
      }
    });

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('A new onMessageOpenedApp event was published!');
    //   Navigator.pushNamed(context, '/message',
    //       arguments: MessageArguments(message, true));
    // });

    _fcm.getToken().then((token) {
      if (token != userAuth["token"]) {
        updateUserToken(token!, userAuth).then((value) {
          getDataUser(userAuth["uid"]).then((value2) {
            storage.put('userAuth', value2.data());
          });
        });
      }
    });
  }

  Future<void> updateUserToken(String token, value) {
    return _authRepository.updateUserToken(token, value);
  }

  Stream<User?> get onAuthStateChanged {
    return _authRepository.onAuthStateChanged;
  }

  Future<DocumentSnapshot> getDataUser(String userId) {
    return _authRepository.getDataUser(userId);
  }

  Future<void> updateDataUser(User user, value) {
    return _authRepository.updateDataUser(user, value);
  }

  Future<void> createUserFirestore(
      String birthDay, String email, String name, String phone) {
    return _authRepository.createUserFirestore(birthDay, email, name, phone);
  }

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) {
    return _authRepository.signInWithEmailAndPassword(email, password);
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _authRepository.sendPasswordResetEmail(email);
  }

  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) {
    return _authRepository.createUserWithEmailAndPassword(email, password);
  }

  Future<void> signOut() {
    return _authRepository.signOut();
  }

  Future<void> deleteUser(String uid) {
    return _authRepository.deleteUser(uid);
  }

  @override
  void dispose() {
    _loadingSubject.close();
  }
}

final authBloc = AuthBloc();
