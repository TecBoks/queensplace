import 'package:bequeen/web_site/screens/web_site_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bequeen/auth/repository/auth_bloc.dart';
import 'package:bequeen/auth/screens/auth_login.dart';
import 'package:bequeen/auth/screens/auth_verify_email.dart';
import 'package:bequeen/home/screens/home.dart';
import 'package:bequeen/home/screens/home_lower.dart';
import 'package:bequeen/utils/loading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SessionHandler extends StatefulWidget {
  const SessionHandler({Key? key}) : super(key: key);

  @override
  State<SessionHandler> createState() => _SessionHandlerState();
}

class _SessionHandlerState extends State<SessionHandler> {
  var userAuth = {};
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final storage = Hive.box("queensPlaceTecBoks");

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      authBloc.setUser(FirebaseAuth.instance.currentUser!);
    }
    if (!kIsWeb) {
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
      var ios = DarwinInitializationSettings(
          onDidReceiveLocalNotification: onDidReceiveLocalNotification);
      var initSettings = InitializationSettings(android: android, iOS: ios);
      flutterLocalNotificationsPlugin.initialize(initSettings,
          onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
    }
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    // await Navigator.push(context,
    //     MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)));
  }

  onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text(title!),
                content: Text(body!),
                actions: [
                  CupertinoDialogAction(
                      isDefaultAction: true,
                      child: const Text('Ok'),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      })
                ]));
  }

  @override
  Widget build(BuildContext context) {
    userAuth = (storage.get('userAuth') == null) ? {} : storage.get('userAuth');
    if (userAuth.isEmpty) {
      return (kIsWeb) ? WebSiteHome() : AuthLogin();
    } else {
      if (!kIsWeb) {
        authBloc.initialise(context, userAuth, storage, showNotification);
      }
      return StreamBuilder<User>(
          stream: authBloc.userStream,
          builder: (context, AsyncSnapshot<User> snapshotUser) {
            authBloc.setUser(FirebaseAuth.instance.currentUser!);
            if (snapshotUser.hasData) {
              if (snapshotUser.data!.emailVerified) {
                return (userAuth["email"] == 'queenplacesps@gmail.com')
                    ? const Home()
                    : const HomeLower();
              } else {
                return AuthVerifyEmail(email: snapshotUser.data!.email);
              }
            } else {
              return const Loading(
                  colorVariable: Color.fromRGBO(255, 255, 255, 1));
            }
          });
    }
  }

  showNotification(title, body) async {
    var android = const AndroidNotificationDetails('channel id', 'channel NAME',
        priority: Priority.high, importance: Importance.max);
    var iOS = const DarwinNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(0, title, body, platform,
        payload: 'AndroidCoding.in');
  }

        // showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return UpdateDialog(
        //           allowDismissal: true,
        //           description: status.localVersion,
        //           version: status.storeVersion,
        //           appLink: status.appStoreLink);
        //     });
}
