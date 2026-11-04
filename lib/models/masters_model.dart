// lib/models/masters_model.dart
// Shared state for Masters and Categories list with search & pagination (L5)

import 'package:flutter/foundation.dart';
import '../data/models.dart';
import '../data/result.dart';
import '../data/repositories/master_repository.dart';

class MastersModel extends ChangeNotifier {
  final MasterRepository _repository;

  MastersModel(this._repository);

  bool _loading = false;
  String? _error;
  List<Master> _masters = const [];
  List<ServiceCategory> _categories = const [];
  String _search = '';
  int _page = 1;
  final int _limit = 20;
  bool _hasMore = false;

  bool get isLoading => _loading;
  String? get error => _error;
  List<Master> get masters => List.unmodifiable(_masters);
  List<Master> get favorites => List.unmodifiable(_masters.where((m) => m.isFavorite).toList());
  List<ServiceCategory> get categories => List.unmodifiable(_categories);
  int get count => _masters.length;
  int get favoritesCount => favorites.length;
  bool get hasMore => _hasMore;
  String get search => _search;

  Master? byId(String id) {
    try {
      return _masters.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> load({String? search}) async {
    _search = search ?? _search;
    _page = 1;
    _loading = true;
    _error = null;
    notifyListeners();

    final mastersResult = await _repository.fetchAll(page: _page, limit: _limit, search: _search);
    final categoriesResult = await _repository.fetchCategories();

    switch (mastersResult) {
      case Ok(:final value):
        _masters = value;
        _hasMore = value.length >= _limit;
      case Err(:final msg):
        _error = msg;
    }

    if (_error == null && categoriesResult is Ok<List<ServiceCategory>>) {
      _categories = categoriesResult.value;
    }

    _loading = false;
    notifyListeners();
  }

  Future<String?> toggleFavorite(String id) async {
    final result = await _repository.toggleFavorite(id);
    switch (result) {
      case Ok(:final value):
        final index = _masters.indexWhere((m) => m.id == id);
        if (index != -1) {
          final updatedList = List<Master>.from(_masters);
          updatedList[index] = value;
          _masters = updatedList;
          notifyListeners();
        }
        return null;
      case Err(:final msg):
        return msg;
    }
  }
}
