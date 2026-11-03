// lib/data/repositories/master_repository.dart
// Repository interface for Master domain entity

import '../models.dart';
import '../result.dart';

abstract class MasterRepository {
  Future<Result<List<Master>>> fetchAll();
  Future<Result<Master>> fetchById(String id);
  Future<Result<Master>> toggleFavorite(String id);
  Future<Result<List<ServiceCategory>>> fetchCategories();
}
