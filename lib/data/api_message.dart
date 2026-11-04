// lib/data/api_message.dart
// Translates backend error envelope into user-friendly localized messages (C8/C9)

import 'dart:convert';
import 'package:http/http.dart' as http;

String apiMessage(http.Response res) {
  try {
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (body.containsKey('error') && body['error'] is Map) {
      final errObj = body['error'] as Map<String, dynamic>;
      final code = errObj['code'] as String? ?? '';
      final msg = errObj['message'] as String? ?? '';

      switch (code) {
        case 'VALIDATION_ERROR':
          return 'Отправленные данные недействительны';
        case 'UNAUTHORIZED':
          return msg.isNotEmpty ? msg : 'Неверный email или пароль';
        case 'EMAIL_TAKEN':
          return 'Аккаунт с этим email уже существует';
        case 'NOT_FOUND':
          return 'Запись не существует';
        default:
          return msg.isNotEmpty ? msg : 'Ошибка сервера (${res.statusCode})';
      }
    }
  } catch (_) {}
  return 'Ошибка сервера (${res.statusCode})';
}
