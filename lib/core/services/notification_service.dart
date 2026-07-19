import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _messaging;
  StreamSubscription<RemoteMessage>? _messageSubscription;

  NotificationService({FirebaseMessaging? messaging})
      : _messaging = messaging ?? FirebaseMessaging.instance;

  Future<void> initialize() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await _messaging.getToken();
      if (token != null) {
        // In production, save this token to the user's Firestore document
        // so Cloud Functions can send targeted notifications.
      }
    }

    _messageSubscription = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // In production, show a local notification here using flutter_local_notifications.
      // For now, we just log it.
    });
  }

  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }

  void dispose() {
    _messageSubscription?.cancel();
  }
}
