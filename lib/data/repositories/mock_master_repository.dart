// lib/data/repositories/mock_master_repository.dart
// Mock implementation of MasterRepository with memory storage, latency & fault simulation

import '../mock_data.dart';
import '../result.dart';
import 'master_repository.dart';

class MockMasterRepository implements MasterRepository {
  final List<Master> _masters = List.of(mockMasters);
  final List<ServiceCategory> _categories = List.of(mockCategories);

  bool simulateError = false; // Fault simulation switcher
  static const _latency = Duration(milliseconds: 800);
  static const _errNetwork = 'Сервер не отвечает — повторите попытку';

  @override
  Future<Result<List<Master>>> fetchAll() async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    return Ok(List.unmodifiable(_masters));
  }

  @override
  Future<Result<Master>> fetchById(String id) async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    final index = _masters.indexWhere((m) => m.id == id);
    if (index == -1) return const Err('Мастер не найден');
    return Ok(_masters[index]);
  }

  @override
  Future<Result<Master>> toggleFavorite(String id) async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    final index = _masters.indexWhere((m) => m.id == id);
    if (index == -1) return const Err('Мастер не найден');

    final master = _masters[index];
    final updated = master.copyWith(isFavorite: !master.isFavorite);
    _masters[index] = updated;
    return Ok(updated);
  }

  @override
  Future<Result<List<ServiceCategory>>> fetchCategories() async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    return Ok(List.unmodifiable(_categories));
  }
}
