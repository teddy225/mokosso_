import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationViewModele {
  //instance flutter local notification
  static final localNotificationInstance = FlutterLocalNotificationsPlugin();

  NotificationViewModele();

  //initialisation de flutter local notification
  static Future<void> intialisationLocalNotification() async {
    //parametre initialisation android
    const android = AndroidInitializationSettings("@mipmap/ic_launcher");
    //parametre initialisation Ios
    const ios = DarwinInitializationSettings();
    //combiner les parametres android et ios
    const initialisationSettings =
        InitializationSettings(android: android, iOS: ios);
    //initialisation du plugin
    await localNotificationInstance.initialize(
      initialisationSettings,
    );
    //demander autorisation notification a android
    await localNotificationInstance
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  //lancer une notification locale instantanée
  static Future<void> showNotificationLocale(int hasCode,
      {required String titre, required String corps}) async {
    //definir les details de notification
    const NotificationDetails platformChannelSpecific = NotificationDetails(
        android: AndroidNotificationDetails("channelId", "channelName",
            icon: "@mipmap/ic_launcher",
            importance: Importance.high,
            priority: Priority.high,
            color: Color(0XFFEF8A26)),
        iOS: DarwinNotificationDetails());
    await localNotificationInstance.show(
        hasCode, titre, corps, platformChannelSpecific);
  }
}
