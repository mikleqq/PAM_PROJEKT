// lib/data/repositories/order_repository.dart
// Repository interface for ServiceOrder domain entity with pagination & search (L5)

import '../models.dart';
import '../result.dart';

abstract class OrderRepository {
  Future<Result<List<ServiceOrder>>> fetchAll({int page = 1, int limit = 20, String? search});
  Future<Result<ServiceOrder>> fetchById(String id);
  Future<Result<ServiceOrder>> create(ServiceOrder order);
  Future<Result<void>> cancel(String id);
}
