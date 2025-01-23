// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:rider/app/app.dialogs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rider/responses/order_response.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rider/app/app.locator.dart';
import 'package:rider/app/app.logger.dart';
import 'package:stacked_services/stacked_services.dart';

class NotificationService {
  final _dialogService = locator<DialogService>();
  final log = getLogger('NotificationService');
  final _fcm = FirebaseMessaging.instance;
  static final AudioPlayer player = AudioPlayer();

  String? fcmToken;
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String type = '';
  late OrderModel order;

  final BehaviorSubject<ReceivedNotification> didReceivedLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();

  /// Initialize local notifications
  _initFlutterLocalNotificationPlugin() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'default',
        'High Importance Notifications',
        importance: Importance.high,
        description: "This is ewanc channel",
        playSound: true,
        enableLights: true,
      );
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings("@mipmap/ic_launcher");

      final DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings();

      final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (payload) async => _onNotificationClick(payload),
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      await _fcm.setForegroundNotificationPresentationOptions(
          alert: true, badge: true, sound: true);
    }
  }

  /// Initializing Notification services that includes FCM and Local Notification settings
  initConfigure() async {
    log.d("@initFCMConfigure/started");
    await _initFlutterLocalNotificationPlugin();
    askPermission();

    await _fcm.getToken().then((token) {
      log.wtf("FCM TOKEN IS ===>$token");
      fcmToken = token;
    });

    _fcm.getInitialMessage().then((message) {
      if (message != null) {
        log.wtf('I am invoked from terminated state');
        type = message.data['type'];
        order = OrderModel.fromJson(jsonDecode(message.data['order']));
        order.isManual = type == "manual";
        showDialog();
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log.wtf('@onMessage');
      if (!kIsWeb) {
        type = message.data['type'];
        order = OrderModel.fromJson(jsonDecode(message.data['order']));
        order.isManual = type == "manual";
        if (!isDialogOpen) {
          const alarmAudioPath = "mp3/custom_sound.mp3";
          player.play(AssetSource(alarmAudioPath));
          showDialog();
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log.wtf('I am invoked from background state');
      type = message.data['type'];
      order = OrderModel.fromJson(jsonDecode(message.data['order']));
      order.isManual = type == "manual";
      showDialog();
    });
  }

  bool isDialogOpen = false;

  showDialog() async {
    isDialogOpen = true;
    await _dialogService.showCustomDialog(
      variant: DialogType.incomnigrequest,
      title: 'Error',
      description: "",
      data: order,
    );
    isDialogOpen = false;
  }

  Future<String?> getFcmToken() async {
    return await _fcm.getToken();
  }

  askPermission() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    log.d('User granted permission: ${settings.authorizationStatus}');
  }


  void _onNotificationClick(NotificationResponse payload) {
    log.wtf('Tapped on notification in foreground state');
    showDialog();
  }
}

class ReceivedNotification {
  final int? id;
  final String? title;
  final String? body;
  final String? payload;

  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}
