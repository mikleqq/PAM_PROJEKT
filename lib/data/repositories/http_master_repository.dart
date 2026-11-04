// lib/data/repositories/http_master_repository.dart
// HTTP implementation of MasterRepository communicating with REST API Backend (L5)

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../api_message.dart';
import '../models.dart';
import '../result.dart';
import '../token_store.dart';
import 'master_repository.dart';

class HttpMasterRepository implements MasterRepository {
  final String baseUrl;
  final TokenStore tokens;
  final void Function()? onUnauthorized;

  HttpMasterRepository(this.baseUrl, this.tokens, {this.onUnauthorized});

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
  Future<Result<List<Master>>> fetchAll({int page = 1, int limit = 20, String? search}) async {
    try {
      final uri = Uri.parse('$baseUrl/masters').replace(queryParameters: {
        'page': '$page',
        'limit': '$limit',
        if (search != null && search.isNotEmpty) 'search': search,
      });

      final res = await http.get(uri, headers: await _headers()).timeout(_timeout);

      if (res.statusCode == 401) return Err(await _sessionDied());
      if (res.statusCode != 200) return Err(apiMessage(res));

      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final items = (data['items'] as List)
          .map((e) => Master.fromJson(e as Map<String, dynamic>))
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
  Future<Result<Master>> fetchById(String id) async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/masters/$id'), headers: await _headers())
          .timeout(_timeout);

      if (res.statusCode == 401) return Err(await _sessionDied());
      if (res.statusCode != 200) return Err(apiMessage(res));

      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return Ok(Master.fromJson(data));
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
  Future<Result<Master>> toggleFavorite(String id) async {
    try {
      final res = await http
          .post(Uri.parse('$baseUrl/masters/$id/favorite'), headers: await _headers())
          .timeout(_timeout);

      if (res.statusCode == 401) return Err(await _sessionDied());
      if (res.statusCode != 200) return Err(apiMessage(res));

      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return Ok(Master.fromJson(data));
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
  Future<Result<List<ServiceCategory>>> fetchCategories() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/categories'), headers: await _headers())
          .timeout(_timeout);

      if (res.statusCode == 401) return Err(await _sessionDied());
      if (res.statusCode != 200) return Err(apiMessage(res));

      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final items = (data['items'] as List)
          .map((e) => ServiceCategory.fromJson(e as Map<String, dynamic>))
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
}
