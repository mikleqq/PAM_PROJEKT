// Widget test for HomeServicesApp

import 'package:flutter_test/flutter_test.dart';
import 'package:home_services/main.dart';

void main() {
  testWidgets('HomeServicesApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HomeServicesApp());

    // Verify that app title exists
    expect(find.text('ПрофиСервис'), findsWidgets);
  });
}
