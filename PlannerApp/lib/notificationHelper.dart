// final BehaviorSubject<ReminderNotification> didReceiveLocalNotificationSubject =
//     BehaviorSubject<ReminderNotification>();

// final BehaviorSubject<String> selectNotificationSubject =
//     BehaviorSubject<String>();

// Future<void> initNotifications(
//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
//   var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
//   var initializationSettings = InitializationSettings(
//       initializationSettingsAndroid);
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//       onSelectNotification: (String payload) async {
//     if (payload != null) {
//       debugPrint('notification payload: ' + payload);
//     }
//     selectNotificationSubject.add(payload);
//   });
// }