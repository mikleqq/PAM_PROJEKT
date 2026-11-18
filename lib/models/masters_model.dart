// lib/models/masters_model.dart
// Shared state for Masters and Categories: search, category filter, sorting (L5)

import 'package:flutter/foundation.dart';
import '../data/models.dart';
import '../data/result.dart';
import '../data/repositories/master_repository.dart';

/// Порядок сортировки списка мастеров.
enum MasterSort { rating, priceAsc }

class MastersModel extends ChangeNotifier {
  final MasterRepository _repository;

  MastersModel(this._repository);

  bool _loading = false;
  String? _error;

  /// Результат последнего запроса с учётом поиска и категории.
  List<Master> _masters = const [];

  /// Все мастера без фильтров — источник для «Избранного» и карточки мастера,
  /// чтобы они не пропадали, когда в списке включён фильтр.
  List<Master> _all = const [];

  List<ServiceCategory> _categories = const [];
  String _search = '';
  String _categoryId = '';
  MasterSort _sort = MasterSort.rating;
  bool _verifiedOnly = false;
  int _page = 1;
  final int _limit = 20;
  bool _hasMore = false;

  bool get isLoading => _loading;
  String? get error => _error;

  /// Отфильтрованный и отсортированный список для экранов.
  List<Master> get masters {
    final list = _masters.where((m) => !_verifiedOnly || m.isVerified).toList();
    switch (_sort) {
      case MasterSort.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
      case MasterSort.priceAsc:
        list.sort((a, b) => a.hourlyRate.compareTo(b.hourlyRate));
    }
    return List.unmodifiable(list);
  }

  /// Лучшие по рейтингу среди всех мастеров (без учёта фильтров) — для каталога.
  List<Master> topRated(int n) {
    final list = [..._all]..sort((a, b) => b.rating.compareTo(a.rating));
    return List.unmodifiable(list.take(n));
  }

  List<Master> get favorites => List.unmodifiable(_all.where((m) => m.isFavorite));
  List<ServiceCategory> get categories => List.unmodifiable(_categories);
  int get count => masters.length;
  int get favoritesCount => favorites.length;
  bool get hasMore => _hasMore;
  String get search => _search;
  String get categoryId => _categoryId;
  MasterSort get sort => _sort;
  bool get verifiedOnly => _verifiedOnly;

  ServiceCategory? categoryById(String id) {
    for (final c in _categories) {
      if (c.id == id) return c;
    }
    return null;
  }

  Master? byId(String id) {
    for (final m in [..._all, ..._masters]) {
      if (m.id == id) return m;
    }
    return null;
  }

  Master? byName(String name) {
    for (final m in _all) {
      if (m.name == name) return m;
    }
    return null;
  }

  /// [search] и [categoryId]: `null` — оставить текущее значение, `''` — сбросить.
  Future<void> load({String? search, String? categoryId}) async {
    _search = search ?? _search;
    _categoryId = categoryId ?? _categoryId;
    _page = 1;
    _loading = true;
    _error = null;
    notifyListeners();

    final filtered = _search.isEmpty && _categoryId.isEmpty;
    final mastersResult = await _repository.fetchAll(
      page: _page,
      limit: _limit,
      search: _search,
      categoryId: _categoryId,
    );

    switch (mastersResult) {
      case Ok(:final value):
        _masters = value;
        _hasMore = value.length >= _limit;
        if (filtered) _all = value;
      case Err(:final msg):
        _error = msg;
    }

    if (_error == null) {
      // Полный список нужен для «Избранного», если основной запрос был с фильтром.
      if (!filtered) {
        final allResult = await _repository.fetchAll(page: 1, limit: 100);
        if (allResult is Ok<List<Master>>) _all = allResult.value;
      }
      final categoriesResult = await _repository.fetchCategories();
      if (categoriesResult is Ok<List<ServiceCategory>>) {
        _categories = categoriesResult.value;
      }
    }

    _loading = false;
    notifyListeners();
  }

  void setSort(MasterSort sort) {
    if (_sort == sort) return;
    _sort = sort;
    notifyListeners();
  }

  void setVerifiedOnly(bool value) {
    if (_verifiedOnly == value) return;
    _verifiedOnly = value;
    notifyListeners();
  }

  /// Сброс состояния при выходе из аккаунта.
  void reset() {
    _masters = const [];
    _all = const [];
    _search = '';
    _categoryId = '';
    _sort = MasterSort.rating;
    _verifiedOnly = false;
    _error = null;
    notifyListeners();
  }

  Future<String?> toggleFavorite(String id) async {
    final result = await _repository.toggleFavorite(id);
    switch (result) {
      case Ok(:final value):
        List<Master> replace(List<Master> list) =>
            [for (final m in list) m.id == id ? value : m];
        _masters = replace(_masters);
        _all = replace(_all);
        notifyListeners();
        return null;
      case Err(:final msg):
        return msg;
    }
  }
}
