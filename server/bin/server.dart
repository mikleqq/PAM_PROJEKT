// C:/dev/home_services/server/bin/server.dart
// Standalone Dart REST API Backend Server for Home Services App (L5)

import 'dart:convert';
import 'dart:io';

const int port = 8080;
const String validTokenPrefix = 'token_auth_user_';

// Seed Memory Databases
final Map<String, Map<String, String>> usersDb = {
  'alex.kovalenko@example.com': {
    'id': '1',
    'email': 'alex.kovalenko@example.com',
    'password': '123456',
    'name': 'Александр Коваленко',
  }
};

final List<Map<String, dynamic>> mastersDb = [
  {
    'id': 'm1',
    'name': 'Алексей Иванов',
    'specialty': 'Сантехник высшей категории',
    'categoryId': 'cat_plumbing',
    'rating': 4.9,
    'reviewsCount': 48,
    'hourlyRate': 350.0,
    'experienceYears': 8,
    'bio': 'Опытный сантехник. Устранение протечек, монтаж труб, установка смесителей.',
    'phone': '+373 69 123 456',
    'isAvailable': true,
    'isVerified': true,
    'skills': ['Монтаж труб', 'Установка сантехники', 'Устранение засоров'],
    'isFavorite': true,
  },
  {
    'id': 'm2',
    'name': 'Иван Петров',
    'specialty': 'Электрик-монтажник',
    'categoryId': 'cat_electric',
    'rating': 4.8,
    'reviewsCount': 36,
    'hourlyRate': 380.0,
    'experienceYears': 10,
    'bio': 'Дипломированный электрик 4 группы допуска. Проводка под ключ.',
    'phone': '+373 68 234 567',
    'isAvailable': true,
    'isVerified': true,
    'skills': ['Замена проводки', 'Монтаж щитков', 'Установка люстр'],
    'isFavorite': true,
  },
  {
    'id': 'm3',
    'name': 'Сергей Смирнов',
    'specialty': 'Универсальный мастер на час',
    'categoryId': 'cat_handyman',
    'rating': 4.7,
    'reviewsCount': 52,
    'hourlyRate': 250.0,
    'experienceYears': 6,
    'bio': 'Быстро и качественно выполню любые мелкие бытовые работы.',
    'phone': '+373 79 345 678',
    'isAvailable': false,
    'isVerified': true,
    'skills': ['Крепление к стенам', 'Мелкий ремонт', 'Замена замков'],
    'isFavorite': false,
  },
  {
    'id': 'm4',
    'name': 'Мария Ковалева',
    'specialty': 'Специалист по клинингу',
    'categoryId': 'cat_cleaning',
    'rating': 5.0,
    'reviewsCount': 64,
    'hourlyRate': 220.0,
    'experienceYears': 5,
    'bio': 'Генеральная уборка квартир и офисов, уборка после ремонта, мойка окон.',
    'phone': '+373 60 456 789',
    'isAvailable': true,
    'isVerified': true,
    'skills': ['Генеральная уборка', 'Мойка окон', 'Уборка после ремонта'],
    'isFavorite': true,
  },
  {
    'id': 'm5',
    'name': 'Павел Сидоров',
    'specialty': 'Мастер по ремонту бытовой техники',
    'categoryId': 'cat_appliance',
    'rating': 4.8,
    'reviewsCount': 29,
    'hourlyRate': 400.0,
    'experienceYears': 12,
    'bio': 'Ремонт стиральных и посудомоечных машин, холодильников, духовки.',
    'phone': '+373 68 567 890',
    'isAvailable': true,
    'isVerified': true,
    'skills': ['Стиральные машины', 'Холодильники', 'Замена ТЭНа'],
    'isFavorite': false,
  },
  {
    'id': 'm6',
    'name': 'Дмитрий Чеботарь',
    'specialty': 'Мастер по сборке корпусной мебели',
    'categoryId': 'cat_furniture',
    'rating': 4.9,
    'reviewsCount': 41,
    'hourlyRate': 280.0,
    'experienceYears': 7,
    'bio': 'Сборка кухонь, шкафов-купе, кроватей любых брендов.',
    'phone': '+373 78 678 901',
    'isAvailable': true,
    'isVerified': true,
    'skills': ['Сборка кухонь', 'Шкафы-купе', 'Врезка моек'],
    'isFavorite': true,
  },
  {
    'id': 'm7',
    'name': 'Михаил Федоров',
    'specialty': 'Специалист по дверям и замкам',
    'categoryId': 'cat_locks',
    'rating': 4.6,
    'reviewsCount': 22,
    'hourlyRate': 320.0,
    'experienceYears': 9,
    'bio': 'Аварийное вскрытие без повреждений, замена личинок.',
    'phone': '+373 69 789 012',
    'isAvailable': false,
    'isVerified': false,
    'skills': ['Вскрытие замков', 'Замена личинок', 'Ремонт дверей'],
    'isFavorite': false,
  },
  {
    'id': 'm8',
    'name': 'Евгений Лупу',
    'specialty': 'Маляр-штукатур',
    'categoryId': 'cat_repair',
    'rating': 4.9,
    'reviewsCount': 38,
    'hourlyRate': 450.0,
    'experienceYears': 11,
    'bio': 'Шпатлевка стеновых поверхностей, покраска, поклейка обоев.',
    'phone': '+373 60 890 123',
    'isAvailable': true,
    'isVerified': true,
    'skills': ['Поклейка обоев', 'Покраска стен', 'Шпатлевка'],
    'isFavorite': false,
  },
];

final List<Map<String, dynamic>> categoriesDb = [
  {'id': 'cat_plumbing', 'name': 'Сантехника', 'iconName': 'water_drop', 'masterCount': 14, 'startingPrice': 250.0},
  {'id': 'cat_electric', 'name': 'Электрика', 'iconName': 'bolt', 'masterCount': 18, 'startingPrice': 300.0},
  {'id': 'cat_cleaning', 'name': 'Уборка и клининг', 'iconName': 'cleaning_services', 'masterCount': 22, 'startingPrice': 200.0},
  {'id': 'cat_appliance', 'name': 'Бытовая техника', 'iconName': 'home_repair_service', 'masterCount': 11, 'startingPrice': 350.0},
  {'id': 'cat_furniture', 'name': 'Сборка мебели', 'iconName': 'chair', 'masterCount': 9, 'startingPrice': 220.0},
  {'id': 'cat_locks', 'name': 'Замки и двери', 'iconName': 'lock', 'masterCount': 8, 'startingPrice': 280.0},
  {'id': 'cat_repair', 'name': 'Косметический ремонт', 'iconName': 'format_paint', 'masterCount': 15, 'startingPrice': 400.0},
  {'id': 'cat_handyman', 'name': 'Мастер на час', 'iconName': 'build', 'masterCount': 25, 'startingPrice': 180.0},
];

final List<Map<String, dynamic>> ordersDb = [
  {
    'id': 'ORD-2026-001',
    'serviceName': 'Замена смесителя на кухне',
    'description': 'Демонтаж старого смесителя, установка нового кухонного смесителя с подводкой.',
    'masterName': 'Алексей Иванов',
    'masterSpecialty': 'Сантехник',
    'masterPhone': '+373 69 123 456',
    'date': '12 Октября 2026',
    'time': '14:00 - 15:30',
    'address': 'г. Кишинев, ул. Штефан чел Маре 132, кв. 45',
    'price': 450.0,
    'status': 'Завершён',
    'paymentMethod': 'Наличными',
  },
  {
    'id': 'ORD-2026-002',
    'serviceName': 'Установка 4 розеток и люстры',
    'description': 'Штробление стены, подведение кабеля, установка 4 розеток и люстры.',
    'masterName': 'Иван Петров',
    'masterSpecialty': 'Электрик',
    'masterPhone': '+373 68 234 567',
    'date': '18 Октября 2026',
    'time': '10:00 - 12:00',
    'address': 'г. Кишинев, Московский проспект 8, кв. 12',
    'price': 600.0,
    'status': 'В процессе',
    'paymentMethod': 'Картой мастеру',
  },
  {
    'id': 'ORD-2026-003',
    'serviceName': 'Генеральная уборка 2-комн. квартиры',
    'description': 'Комплексная влажная уборка комнат, протирка поверхностей.',
    'masterName': 'Мария Ковалева',
    'masterSpecialty': 'Клининг',
    'masterPhone': '+373 60 456 789',
    'date': '22 Октября 2026',
    'time': '09:00 - 14:00',
    'address': 'г. Кишинев, ул. Дачия 24, кв. 89',
    'price': 1100.0,
    'status': 'Ожидает',
    'paymentMethod': 'Наличными мастеру',
  },
];

int orderCounter = 4;

void main() async {
  final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
  print('✅ Server listening on http://localhost:$port (or http://10.0.2.2:$port for emulator)');

  await for (HttpRequest request in server) {
    _handleRequest(request);
  }
}

Future<void> _handleRequest(HttpRequest req) async {
  // CORS Headers
  req.response.headers.add('Access-Control-Allow-Origin', '*');
  req.response.headers.add('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  req.response.headers.add('Access-Control-Allow-Headers', 'Origin, Content-Type, Authorization');

  if (req.method == 'OPTIONS') {
    req.response.statusCode = HttpStatus.ok;
    await req.response.close();
    return;
  }

  final path = req.uri.path;
  final method = req.method;

  try {
    // 1. Health check
    if (path == '/health' && method == 'GET') {
      _sendJson(req, {'status': 'ok'});
      return;
    }

    // 2. Auth: Register
    if (path == '/auth/register' && method == 'POST') {
      final body = await _readJson(req);
      final email = (body['email'] as String? ?? '').trim();
      final password = body['password'] as String? ?? '';
      final name = (body['name'] as String? ?? '').trim();

      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        _sendJson(
          req,
          {
            'error': {'code': 'VALIDATION_ERROR', 'message': 'Все поля обязательны'}
          },
          status: HttpStatus.badRequest,
        );
        return;
      }

      if (usersDb.containsKey(email)) {
        _sendJson(
          req,
          {
            'error': {'code': 'EMAIL_TAKEN', 'message': 'Аккаунт с этим email уже существует'}
          },
          status: HttpStatus.conflict,
        );
        return;
      }

      final userId = '${usersDb.length + 1}';
      usersDb[email] = {'id': userId, 'email': email, 'password': password, 'name': name};
      final token = '$validTokenPrefix$userId';

      _sendJson(
        req,
        {
          'token': token,
          'user': {'id': userId, 'email': email, 'name': name}
        },
        status: HttpStatus.created,
      );
      return;
    }

    // 3. Auth: Login
    if (path == '/auth/login' && method == 'POST') {
      final body = await _readJson(req);
      final email = (body['email'] as String? ?? '').trim();
      final password = body['password'] as String? ?? '';

      final user = usersDb[email];
      if (user == null || user['password'] != password) {
        _sendJson(
          req,
          {
            'error': {'code': 'UNAUTHORIZED', 'message': 'Неверный email или пароль'}
          },
          status: HttpStatus.unauthorized,
        );
        return;
      }

      final token = '$validTokenPrefix${user['id']}';
      _sendJson(
        req,
        {
          'token': token,
          'user': {'id': user['id'], 'email': user['email'], 'name': user['name']}
        },
      );
      return;
    }

    // Auth Middleware for remaining protected endpoints
    final authHeader = req.headers.value('authorization') ?? '';
    if (!authHeader.startsWith('Bearer $validTokenPrefix')) {
      _sendJson(
        req,
        {
          'error': {'code': 'UNAUTHORIZED', 'message': 'Токен недействителен или отсутствует'}
        },
        status: HttpStatus.unauthorized,
      );
      return;
    }

    // 4. Categories list
    if (path == '/categories' && method == 'GET') {
      _sendJson(req, {'items': categoriesDb});
      return;
    }

    // 5. Masters list (with search, page, limit)
    if (path == '/masters' && method == 'GET') {
      final search = (req.uri.queryParameters['search'] ?? '').toLowerCase();
      final page = int.tryParse(req.uri.queryParameters['page'] ?? '1') ?? 1;
      final limit = int.tryParse(req.uri.queryParameters['limit'] ?? '20') ?? 20;

      var filtered = mastersDb.where((m) {
        if (search.isEmpty) return true;
        final name = (m['name'] as String).toLowerCase();
        final specialty = (m['specialty'] as String).toLowerCase();
        final skills = (m['skills'] as List).map((s) => s.toString().toLowerCase()).join(' ');
        return name.contains(search) || specialty.contains(search) || skills.contains(search);
      }).toList();

      final total = filtered.length;
      final startIndex = (page - 1) * limit;
      final pagedItems = startIndex < total
          ? filtered.sublist(startIndex, (startIndex + limit).clamp(0, total))
          : [];

      _sendJson(req, {
        'items': pagedItems,
        'page': page,
        'limit': limit,
        'total': total,
      });
      return;
    }

    // 6. Master details
    if (path.startsWith('/masters/') && method == 'GET') {
      final id = path.substring('/masters/'.length);
      final master = mastersDb.firstWhere((m) => m['id'] == id, orElse: () => {});
      if (master.isEmpty) {
        _sendJson(
          req,
          {
            'error': {'code': 'NOT_FOUND', 'message': 'Мастер не найден'}
          },
          status: HttpStatus.notFound,
        );
        return;
      }
      _sendJson(req, master);
      return;
    }

    // 7. Toggle Master Favorite
    if (path.startsWith('/masters/') && path.endsWith('/favorite') && method == 'POST') {
      final id = path.substring('/masters/'.length, path.length - '/favorite'.length);
      final index = mastersDb.indexWhere((m) => m['id'] == id);
      if (index == -1) {
        _sendJson(
          req,
          {
            'error': {'code': 'NOT_FOUND', 'message': 'Мастер не найден'}
          },
          status: HttpStatus.notFound,
        );
        return;
      }
      mastersDb[index]['isFavorite'] = !(mastersDb[index]['isFavorite'] as bool);
      _sendJson(req, mastersDb[index]);
      return;
    }

    // 8. Orders list (with search, page, limit)
    if (path == '/orders' && method == 'GET') {
      final search = (req.uri.queryParameters['search'] ?? '').toLowerCase();
      final page = int.tryParse(req.uri.queryParameters['page'] ?? '1') ?? 1;
      final limit = int.tryParse(req.uri.queryParameters['limit'] ?? '20') ?? 20;

      var filtered = ordersDb.where((o) {
        if (search.isEmpty) return true;
        final service = (o['serviceName'] as String).toLowerCase();
        final master = (o['masterName'] as String).toLowerCase();
        final id = (o['id'] as String).toLowerCase();
        return service.contains(search) || master.contains(search) || id.contains(search);
      }).toList();

      final total = filtered.length;
      final startIndex = (page - 1) * limit;
      final pagedItems = startIndex < total
          ? filtered.sublist(startIndex, (startIndex + limit).clamp(0, total))
          : [];

      _sendJson(req, {
        'items': pagedItems,
        'page': page,
        'limit': limit,
        'total': total,
      });
      return;
    }

    // 9. Create Order
    if (path == '/orders' && method == 'POST') {
      final body = await _readJson(req);
      final newId = 'ORD-2026-00${orderCounter++}';
      body['id'] = newId;

      ordersDb.insert(0, body);
      _sendJson(req, body, status: HttpStatus.created);
      return;
    }

    // 10. Cancel Order
    if (path.startsWith('/orders/') && method == 'DELETE') {
      final id = path.substring('/orders/'.length);
      final index = ordersDb.indexWhere((o) => o['id'] == id);
      if (index == -1) {
        _sendJson(
          req,
          {
            'error': {'code': 'NOT_FOUND', 'message': 'Заказ не найден'}
          },
          status: HttpStatus.notFound,
        );
        return;
      }
      ordersDb[index]['status'] = 'Отменён';
      req.response.statusCode = HttpStatus.noContent;
      await req.response.close();
      return;
    }

    // 404 Fallback
    _sendJson(
      req,
      {
        'error': {'code': 'NOT_FOUND', 'message': 'Маршрут не существует'}
      },
      status: HttpStatus.notFound,
    );
  } catch (e) {
    _sendJson(
      req,
      {
        'error': {'code': 'SERVER_ERROR', 'message': 'Внутренняя ошибка сервера'}
      },
      status: HttpStatus.internalServerError,
    );
  }
}

Future<Map<String, dynamic>> _readJson(HttpRequest req) async {
  final bodyStr = await utf8.decoder.bind(req).join();
  if (bodyStr.isEmpty) return {};
  return jsonDecode(bodyStr) as Map<String, dynamic>;
}

void _sendJson(HttpRequest req, Map<String, dynamic> data, {int status = HttpStatus.ok}) {
  req.response.statusCode = status;
  req.response.headers.contentType = ContentType.json;
  req.response.write(jsonEncode(data));
  req.response.close();
}
