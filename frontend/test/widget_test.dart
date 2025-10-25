// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:deliver_gaz/main.dart';

void main() {
  testWidgets('App renders Sign In page', (tester) async {
    // Build the app
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

  // Basic smoke assertion: the default English title from i18n is visible
  expect(find.text('Sign In'), findsWidgets);
  });
}
