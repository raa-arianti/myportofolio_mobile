import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

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

  testWidgets('tiap tombol memunculkan SnackBar sesuai namanya', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    for (final item in items) {
      await tester.tap(find.text(item.name));
      await tester.pumpAndSettle();

      expect(
        find.text('Kamu telah menekan tombol ${item.name}!'),
        findsOneWidget,
      );
      // SnackBar memakai warna tombol yang ditekan.
      expect(
        tester.widget<SnackBar>(find.byType(SnackBar)).backgroundColor,
        item.color,
      );

      // Tombol yang punya halaman tujuan membuka halaman itu; kembali dulu ke
      // menu untuk tombol berikutnya.
      if (item.page != null) {
        await tester.binding.handlePopRoute(); // tombol Back sistem
        await tester.pumpAndSettle();
      }
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

  testWidgets('tombol Tambah Proyek membuka form, Back kembali ke menu', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectFormPage), findsOneWidget);

    // Form punya drawer, jadi AppBar-nya berisi ikon menu, bukan panah Back.
    // Kembali ke menu memakai tombol Back sistem (HP/browser), sesuai tutorial.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(MyHomePage), findsOneWidget);
  });

  testWidgets('drawer berpindah ke form dan kembali ke Home', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectFormPage), findsOneWidget);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.byType(MyHomePage), findsOneWidget);
  });

  testWidgets(
    'form menolak kolom wajib kosong dan menampilkan isian di pop-up',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
      expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);
      expect(find.byType(AlertDialog), findsNothing);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nama Proyek'),
        'Sayangin',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Deskripsi Proyek'),
        'Marketplace preloved',
      );
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
      expect(find.text('Nama Proyek: Sayangin'), findsOneWidget);
      expect(find.text('Kategori: Web Development'), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
    },
  );
}
