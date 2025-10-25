import 'package:deliver_gaz/l10n/app_localizations.dart';
import 'package:deliver_gaz/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeApp(Widget home) => MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('fr'), Locale('es')],
        home: home,
      );

  testWidgets('OrdersPage renders and shows My Orders title', (tester) async {
    await tester.pumpWidget(makeApp(const OrdersPage()));
    await tester.pumpAndSettle();

    expect(find.text('My Orders'), findsOneWidget);

    // Open overflow menu
    final overflow = find.byType(PopupMenuButton<String>);
    expect(overflow, findsOneWidget);
    await tester.tap(overflow);
    await tester.pumpAndSettle();

    // Verify refresh option exists (text may be long; ensure it appears without overflow)
    expect(find.textContaining('Refresh'), findsWidgets);
  });
}
