// lib/data/repositories/http_order_repository.dart
// HTTP implementation of OrderRepository communicating with REST API Backend (L5)

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../api_message.dart';
import '../models.dart';
import '../result.dart';
import '../token_store.dart';
import 'order_repository.dart';

class HttpOrderRepository implements OrderRepository {
  final String baseUrl;
  final TokenStore tokens;
  final void Function()? onUnauthorized;

  HttpOrderRepository(this.baseUrl, this.tokens, {this.onUnauthorized});

  static const _timeout = Duration(seconds: 8);

  Future<Map<String, String>> _headers() async => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await tokens.read() ?? ''}',
      };

  Future<String> _sessionDied() async {
    await tokens.clear();
    onUnauthorized?.call();
    return 'Сессия истекла — войдите снова';
  }

  @override
  Future<Result<List<ServiceOrder>>> fetchAll({int page = 1, int limit = 20, String? search}) async {
    try {
      final uri = Uri.parse('$baseUrl/orders').replace(queryParameters: {
        'page': '$page',
        'limit': '$limit',
        if (search != null && search.isNotEmpty) 'search': search,
      });

      final res = await http.get(uri, headers: await _headers()).timeout(_timeout);

      if (res.statusCode == 401) return Err(await _sessionDied());
      if (res.statusCode != 200) return Err(apiMessage(res));

      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final items = (data['items'] as List)
          .map((e) => ServiceOrder.fromJson(e as Map<String, dynamic>))
          .toList();

      return Ok(items);
    } on SocketException {
      return const Err('Нет сети — повторите попытку');
    } on TimeoutException {
      return const Err('Сервер не отвечает');
    } on FormatException {
      return const Err('Ответ не тот, что обещан');
    } on TypeError {
      return const Err('Ответ не тот, что обещан');
    }
  }

  @override
  Future<Result<ServiceOrder>> fetchById(String id) async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/orders/$id'), headers: await _headers())
          .timeout(_timeout);

      if (res.statusCode == 401) return Err(await _sessionDied());
      if (res.statusCode != 200) return Err(apiMessage(res));

      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return Ok(ServiceOrder.fromJson(data));
    } on SocketException {
      return const Err('Нет сети — повторите попытку');
    } on TimeoutException {
      return const Err('Сервер не отвечает');
    } on FormatException {
      return const Err('Ответ не тот, что обещан');
    } on TypeError {
      return const Err('Ответ не тот, что обещан');
    }
  }

  @override
  Future<Result<ServiceOrder>> create(ServiceOrder order) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/orders'),
            headers: await _headers(),
            body: jsonEncode(order.toJson()),
          )
          .timeout(_timeout);

      if (res.statusCode == 401) return Err(await _sessionDied());
      if (res.statusCode != 201 && res.statusCode != 200) return Err(apiMessage(res));

      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return Ok(ServiceOrder.fromJson(data));
    } on SocketException {
      return const Err('Нет сети — повторите попытку');
    } on TimeoutException {
      return const Err('Сервер не отвечает');
    } on FormatException {
      return const Err('Ответ не тот, что обещан');
    } on TypeError {
      return const Err('Ответ не тот, что обещан');
    }
  }

  @override
  Future<Result<void>> cancel(String id) async {
    try {
      final res = await http
          .delete(Uri.parse('$baseUrl/orders/$id'), headers: await _headers())
          .timeout(_timeout);

      if (res.statusCode == 401) return Err(await _sessionDied());
      if (res.statusCode != 204 && res.statusCode != 200) return Err(apiMessage(res));

      return const Ok(null);
    } on SocketException {
      return const Err('Нет сети — повторите попытку');
    } on TimeoutException {
      return const Err('Сервер не отвечает');
    } on FormatException {
      return const Err('Ответ не тот, что обещан');
    } on TypeError {
      return const Err('Ответ не тот, что обещан');
    }
  }
}
