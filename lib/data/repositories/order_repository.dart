// lib/data/repositories/order_repository.dart
// Repository interface for ServiceOrder domain entity

import '../models.dart';
import '../result.dart';

abstract class OrderRepository {
  Future<Result<List<ServiceOrder>>> fetchAll();
  Future<Result<ServiceOrder>> fetchById(String id);
  Future<Result<ServiceOrder>> create(ServiceOrder order);
  Future<Result<void>> cancel(String id);
}
