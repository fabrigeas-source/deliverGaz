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

  testWidgets('ShoppingCartPage renders and shows cart UI', (tester) async {
    await tester.pumpWidget(makeApp(const ShoppingCartPage()));
    // Initial progress indicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Let mock API delay elapse and UI settle
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    // App bar title should contain 'Shopping Cart'
    expect(find.textContaining('Shopping Cart'), findsWidgets);
  });
}
