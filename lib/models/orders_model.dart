// lib/models/orders_model.dart
// Shared state for Service Orders with loading/data/error triad

import 'package:flutter/foundation.dart';
import '../data/models.dart';
import '../data/result.dart';
import '../data/repositories/order_repository.dart';

class OrdersModel extends ChangeNotifier {
  final OrderRepository _repository;

  OrdersModel(this._repository);

  bool _loading = false;
  String? _error;
  List<ServiceOrder> _orders = const [];

  bool get isLoading => _loading;
  String? get error => _error;
  List<ServiceOrder> get orders => List.unmodifiable(_orders);
  int get count => _orders.length;
  int get activeCount => _orders.where((o) => o.status == 'В процессе' || o.status == 'Ожидает').length;

  ServiceOrder? byId(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.fetchAll();
    switch (result) {
      case Ok(:final value):
        _orders = value;
      case Err(:final msg):
        _error = msg;
    }

    _loading = false;
    notifyListeners();
  }

  Future<String?> createOrder(ServiceOrder draft) async {
    final result = await _repository.create(draft);
    switch (result) {
      case Ok(:final value):
        _orders = [value, ..._orders];
        notifyListeners();
        return null;
      case Err(:final msg):
        return msg;
    }
  }

  Future<String?> cancelOrder(String id) async {
    final result = await _repository.cancel(id);
    switch (result) {
      case Ok():
        final index = _orders.indexWhere((o) => o.id == id);
        if (index != -1) {
          final updatedList = List<ServiceOrder>.from(_orders);
          updatedList[index] = updatedList[index].copyWith(status: 'Отменён');
          _orders = updatedList;
          notifyListeners();
        }
        return null;
      case Err(:final msg):
        return msg;
    }
  }
}
