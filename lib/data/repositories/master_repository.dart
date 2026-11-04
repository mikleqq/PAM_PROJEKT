// lib/data/repositories/master_repository.dart
// Repository interface for Master domain entity with pagination & search (L5)

import '../models.dart';
import '../result.dart';

abstract class MasterRepository {
  Future<Result<List<Master>>> fetchAll({int page = 1, int limit = 20, String? search});
  Future<Result<Master>> fetchById(String id);
  Future<Result<Master>> toggleFavorite(String id);
  Future<Result<List<ServiceCategory>>> fetchCategories();
}
