// lib/data/repositories/mock_order_repository.dart
// Mock implementation of OrderRepository with memory storage, latency & fault simulation

import '../mock_data.dart';
import '../result.dart';
import 'order_repository.dart';

class MockOrderRepository implements OrderRepository {
  final List<ServiceOrder> _orders = List.of(mockOrders);
  int _nextIdSequence = 7;

  bool simulateError = false; // Fault simulation switcher
  static const _latency = Duration(milliseconds: 800);
  static const _errNetwork = 'Сервер не отвечает — повторите попытку';

  @override
  Future<Result<List<ServiceOrder>>> fetchAll() async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    return Ok(List.unmodifiable(_orders));
  }

  @override
  Future<Result<ServiceOrder>> fetchById(String id) async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    final index = _orders.indexWhere((o) => o.id == id);
    if (index == -1) return const Err('Заказ не найден');
    return Ok(_orders[index]);
  }

  @override
  Future<Result<ServiceOrder>> create(ServiceOrder draft) async {
    await Future.delayed(_latency);
    if (simulateError) return const Err('Ошибка создания заказа — повторите попытку');

    final newId = 'ORD-2026-00${_nextIdSequence++}';
    final created = draft.copyWith(id: newId);
    _orders.insert(0, created); // Add at beginning of list
    return Ok(created);
  }

  @override
  Future<Result<void>> cancel(String id) async {
    await Future.delayed(_latency);
    if (simulateError) return const Err('Не удалось отменить заказ');

    final index = _orders.indexWhere((o) => o.id == id);
    if (index == -1) return const Err('Заказ не найден');

    final order = _orders[index];
    _orders[index] = order.copyWith(status: 'Отменён');
    return const Ok(null);
  }
}
