// test/dart_exercises_l1.dart
// Solutions for Laboratory Work No. 1 - Dart Exercises E1-E6

import 'dart:async';

// E1. Variables & Null Safety
int parseOrDefault(String? input, int fallback) {
  if (input == null) return fallback;
  return int.tryParse(input) ?? fallback;
}

// E2. Collections & Functional Methods
double promotedAverage(List<int> grades) {
  final passingGrades = grades.where((g) => g >= 5).toList();
  if (passingGrades.isEmpty) return 0.0;
  final sum = passingGrades.reduce((a, b) => a + b);
  return sum / passingGrades.length;
}

// E3. Named & Optional Parameters
String formatPrice(double amount, {String currency = 'MDL', int decimals = 2}) {
  return '${amount.toStringAsFixed(decimals)} $currency';
}

// E4. Classes, Named Constructor, Equality & HashCode
class Student {
  final String name;
  final String group;

  Student(this.name, this.group);

  Student.guest()
      : name = 'Guest',
        group = '—';

  @override
  String toString() => 'Student($name, $group)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Student &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          group == other.group;

  @override
  int get hashCode => name.hashCode ^ group.hashCode;
}

// E5. Mixin
mixin Loggable {
  void log(String msg) {
    print('[$runtimeType] $msg');
  }
}

class CartService with Loggable {
  void addItem(String item) {
    log('товар добавлен: $item');
  }
}

class AuthService with Loggable {
  void login(String username) {
    log('пользователь вошёл: $username');
  }
}

// E6. Async Programming
Future<String> fetchProfile(String username) async {
  await Future.delayed(const Duration(seconds: 2));
  return 'Профиль: $username, группа TI-231, решено упражнений: 42';
}

Future<void> main() async {
  print('=== E1. Переменные и null safety ===');
  print('parseOrDefault("42", 0) -> ${parseOrDefault('42', 0)}');
  print('parseOrDefault("abc", 0) -> ${parseOrDefault('abc', 0)}');
  print('parseOrDefault(null, 7) -> ${parseOrDefault(null, 7)}');
  print('parseOrDefault("7.5", -1) -> ${parseOrDefault('7.5', -1)}');

  print('\n=== E2. Коллекции и функциональные методы ===');
  print('promotedAverage([9, 4, 7, 10, 3, 5]) -> ${promotedAverage([9, 4, 7, 10, 3, 5])}');
  print('promotedAverage([10, 10, 9]) -> ${promotedAverage([10, 10, 9])}');
  print('promotedAverage([3, 4, 2]) -> ${promotedAverage([3, 4, 2])}');

  print('\n=== E3. Именованные и необязательные параметры ===');
  print('formatPrice(12.5) -> "${formatPrice(12.5)}"');
  print('formatPrice(12.5, currency: "MDL") -> "${formatPrice(12.5, currency: "MDL")}"');
  print('formatPrice(99.999, currency: "EUR") -> "${formatPrice(99.999, currency: 'EUR')}"');
  print('formatPrice(7.5, currency: "USD", decimals: 1) -> "${formatPrice(7.5, currency: 'USD', decimals: 1)}"');

  print('\n=== E4. Классы ===');
  print(Student('Ana Rusu', 'TI-231'));
  print(Student.guest());
  print('Student("Ana Rusu", "TI-231") == Student("Ana Rusu", "TI-231") -> ${Student("Ana Rusu", "TI-231") == Student("Ana Rusu", "TI-231")}');
  final set = {Student('Ana Rusu', 'TI-231'), Student('Ana Rusu', 'TI-231')};
  print('Set length -> ${set.length}');

  print('\n=== E5. Mixin ===');
  CartService().addItem('Paracetamol');
  AuthService().login('ana.rusu');

  print('\n=== E6. Асинхронное программирование ===');
  print('Загружается профиль пользователя ana.rusu...');
  final profile = await fetchProfile('ana.rusu');
  print(profile);
  print('Готово.');
}
