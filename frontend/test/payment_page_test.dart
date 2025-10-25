import 'package:deliver_gaz/l10n/app_localizations.dart';
import 'package:deliver_gaz/pages.dart';
import 'package:deliver_gaz/models.dart';
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

  testWidgets('PaymentPage renders and allows selecting delivery option', (tester) async {
    final items = [
      CartItem(id: 'id1', name: 'Test', price: 10.0, quantity: 1, image: Icons.tapas),
    ];
    await tester.pumpWidget(makeApp(PaymentPage(cartItems: items, totalAmount: 10.0)));
  await tester.pumpAndSettle();

  // Select Pay on Delivery to reveal delivery information section
  expect(find.text('Pay on Delivery'), findsOneWidget);
  await tester.tap(find.text('Pay on Delivery'));
  await tester.pumpAndSettle();

  // Verify delivery options section is present now
  expect(find.text('Delivery Options'), findsOneWidget);
  expect(find.text('Express Delivery (1-2 hours)'), findsOneWidget);

    // Tap express delivery list tile
  await tester.tap(find.text('Express Delivery (1-2 hours)'));
    await tester.pumpAndSettle();

    // Still on the page
    expect(find.text('Payment'), findsWidgets);
  });
}
