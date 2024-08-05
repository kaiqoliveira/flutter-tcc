import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    initPushNotifications();
  }

  Future<void> initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    print('ok');
  }

  Future<void> sendNotification(String token) async {
    // Obtenha a chave do servidor correta do seu projeto Firebase
    String serverKey = 'AIzaSyAhryl3fHIEOAHlyLqRGhu24jFxeEju8qc'; // Substitua por sua chave de API

    // Crie a mensagem com a carga útil da notificação
    String constructFCMPayload(String token) {
      return jsonEncode(<String, dynamic>{
        'notification': <String, dynamic>{
          'body': "Deu certo porra",
          'title': "Ihuuulll",
        },
        'data': <String, dynamic>{
          'name': 'Teste',
          'status': 'Okay hudson',
        },
        'to': token,
      });
    }

    if (token.isEmpty) {
      print('Não foi possível enviar a mensagem FCM, nenhum token existe.');
      return;
    }

    try {
      // Envie a mensagem
      http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: constructFCMPayload(token),
      );

      if (response.statusCode == 200) {
        print("status: ${response.statusCode} | Mensagem enviada com sucesso!");
      } else {
        print("Erro ao enviar notificação: ${response.statusCode}");
      }
    } catch (e) {
      print("Erro ao enviar notificação: $e");
    }
  }
}
