import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/menu.dart';

void main() {
  final items = const MyHomePage().items;

  testWidgets('kartu profil menampilkan identitas pemilik', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('2506551775'), findsOneWidget);
    expect(find.text('Ira Arianti Alawiah'), findsOneWidget);
    expect(find.text('PBP D'), findsOneWidget);
  });

  test('ada minimal 3 tombol dan warnanya berbeda semua', () {
    expect(items.length, greaterThanOrEqualTo(3));
    expect(items.map((item) => item.color).toSet().length, items.length);
  });

  testWidgets('tiap tombol memunculkan SnackBar sesuai namanya', (tester) async {
    await tester.pumpWidget(const MyApp());

    for (final item in items) {
      await tester.tap(find.text(item.name));
      await tester.pumpAndSettle();

      expect(find.text('Kamu telah menekan tombol ${item.name}!'), findsOneWidget);
      // SnackBar memakai warna tombol yang ditekan.
      expect(tester.widget<SnackBar>(find.byType(SnackBar)).backgroundColor, item.color);
    }
  });

  testWidgets('tombol Tutup menyembunyikan SnackBar', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsNothing);
  });
}
