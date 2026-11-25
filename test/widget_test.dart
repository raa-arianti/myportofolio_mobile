import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_detail_screen.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';

import 'fake_api.dart';

Future<void> login(WidgetTester tester) async {
  expect(find.byType(LoginScreen), findsOneWidget);
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Username'),
    'owner',
  );
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Password'),
    'secret',
  );
  await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
  await tester.pumpAndSettle();
}

void main() {
  final items = const MyHomePage().items;

  testWidgets('kartu profil menampilkan identitas pemilik', (tester) async {
    await tester.pumpWidget(MyApp(apiClient: fakeApi()));

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
    await tester.pumpWidget(MyApp(apiClient: fakeApi()));

    for (final item in items.where((item) => !item.isLogout)) {
      await tester.ensureVisible(find.text(item.name));
      await tester.tap(find.text(item.name));
      await tester.pumpAndSettle();

      expect(
        find.text('Kamu telah menekan tombol ${item.name}!'),
        findsOneWidget,
      );
      expect(
        tester.widget<SnackBar>(find.byType(SnackBar)).backgroundColor,
        item.color,
      );

      // Halaman tujuan (atau layar login) ditutup dulu sebelum tombol berikutnya.
      if (item.page != null) {
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
      }
    }
  });

  testWidgets('Lihat Proyek memuat data API lalu membuka detail', (
    tester,
  ) async {
    await tester.pumpWidget(MyApp(apiClient: fakeApi()));

    await tester.tap(find.text('Lihat Proyek'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectListScreen), findsOneWidget);
    expect(find.text('Sortify'), findsOneWidget);

    await tester.tap(find.text('Sortify'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectDetailScreen), findsOneWidget);
    expect(find.text('Starred by: a, b'), findsOneWidget);
  });

  testWidgets('Tambah Proyek meminta login dulu, lalu membuka form', (
    tester,
  ) async {
    await tester.pumpWidget(MyApp(apiClient: fakeApi()));

    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    await login(tester);
    expect(find.byType(ProjectFormPage), findsOneWidget);

    // Sudah login: kembali ke menu, lalu form langsung terbuka tanpa login.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectFormPage), findsOneWidget);
  });

  testWidgets('password salah menampilkan SnackBar dan tetap di login', (
    tester,
  ) async {
    await tester.pumpWidget(MyApp(apiClient: fakeApi()));

    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Username'),
      'owner',
    );
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'x');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Login failed (status 400).'), findsOneWidget);
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('drawer menampilkan Login, lalu Logout setelah login', (
    tester,
  ) async {
    await tester.pumpWidget(MyApp(apiClient: fakeApi()));

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ListTile, 'Logout'), findsNothing);
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    await login(tester);

    // Kartu Logout di menu sekarang mencabut token.
    await tester.tap(find.byType(ModalBarrier).last);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ListTile, 'Logout'), findsOneWidget);
    await tester.tap(find.widgetWithText(ListTile, 'Logout'));
    await tester.pumpAndSettle();
    expect(find.text('Kamu berhasil logout.'), findsOneWidget);
  });

  testWidgets('tombol Tutup menyembunyikan SnackBar', (tester) async {
    await tester.pumpWidget(MyApp(apiClient: fakeApi()));

    await tester.ensureVisible(find.text('Logout'));
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();
    expect(find.text('Kamu belum login.'), findsOneWidget);
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('form proyek memvalidasi lalu POST dengan header Token', (
    tester,
  ) async {
    final requests = <http.Request>[];
    await tester.pumpWidget(MyApp(apiClient: fakeApi(requests: requests)));
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    await login(tester);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Title tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Description tidak boleh kosong!'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Title'),
      'Sayangin',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Description'),
      'Marketplace preloved',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Thumbnail'),
      'sortify-card.png',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final post = requests.last;
    expect(post.method, 'POST');
    expect(post.headers['Authorization'], 'Token abc123');
    expect(jsonDecode(post.body), {
      'title': 'Sayangin',
      'description': 'Marketplace preloved',
      'thumbnail': 'sortify-card.png',
    });
    expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
    expect(find.text('Judul: Sayangin'), findsOneWidget);
  });
}
