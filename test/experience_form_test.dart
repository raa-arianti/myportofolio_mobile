import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/experience_list_screen.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/menu.dart';

import 'fake_api.dart';

// Form Experience: dibuka dari kartu dan drawer (wajib login), validasi,
// POST ke /api/v1/experience/ dengan token, serta penanganan 401 dan 403.

Finder field(String label) => find.widgetWithText(TextFormField, label);

/// Menekan Simpan; tombolnya digulir dulu ke layar kalau tertutup.
Future<void> tapSave(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Simpan'));
  await tester.tap(find.text('Simpan'));
  await tester.pumpAndSettle();
}

Future<void> openDrawer(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Open navigation menu'));
  await tester.pumpAndSettle();
}

Future<void> login(WidgetTester tester) async {
  expect(find.byType(LoginScreen), findsOneWidget);
  await tester.enterText(field('Username'), 'owner');
  await tester.enterText(field('Password'), 'secret');
  await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
  await tester.pumpAndSettle();
}

Future<void> fillValid(WidgetTester tester) async {
  await tester.enterText(field('Judul / peran'), '  Staff Pengmas BEM  ');
  await tester.enterText(field('Deskripsi'), 'Mengajar anak-anak');
  await tester.tap(find.text('Full-Time'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Volunteer').last);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('kartu Tambah Experience meminta login, lalu membuka form', (
    tester,
  ) async {
    await tester.pumpWidget(MyApp(apiClient: fakeApi()));

    await tester.ensureVisible(find.text('Tambah Experience'));
    await tester.tap(find.text('Tambah Experience'));
    await tester.pumpAndSettle();
    await login(tester);
    expect(find.byType(ExperienceFormPage), findsOneWidget);

    await tester.binding.handlePopRoute(); // tombol Back bawaan perangkat
    await tester.pumpAndSettle();
    expect(find.byType(MyHomePage), findsOneWidget);
  });

  testWidgets('batal login berarti form tidak dibuka', (tester) async {
    await tester.pumpWidget(MyApp(apiClient: fakeApi()));

    await tester.ensureVisible(find.text('Tambah Experience'));
    await tester.tap(find.text('Tambah Experience'));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute(); // keluar dari layar login
    await tester.pumpAndSettle();

    expect(find.byType(ExperienceFormPage), findsNothing);
    expect(find.byType(MyHomePage), findsOneWidget);
  });

  testWidgets('drawer: Add Experience minta login, Home kembali ke menu', (
    tester,
  ) async {
    await tester.pumpWidget(MyApp(apiClient: fakeApi()));

    await openDrawer(tester);
    expect(find.text('View Experience'), findsOneWidget);
    await tester.tap(find.text('Add Experience'));
    await tester.pumpAndSettle();
    await login(tester);
    expect(find.byType(ExperienceFormPage), findsOneWidget);

    await openDrawer(tester); // drawer yang sama ada di halaman form
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.byType(MyHomePage), findsOneWidget);
    expect(find.byType(ExperienceFormPage), findsNothing);
  });

  testWidgets('input tidak valid ditolak dan tidak ada request', (
    tester,
  ) async {
    final requests = <http.Request>[];
    await tester.pumpWidget(
      withProviders(
        fakeApi(requests: requests),
        const ExperienceFormPage(),
        token: 'abc123',
      ),
    );

    await tapSave(tester);
    expect(find.text('Judul tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi tidak boleh kosong!'), findsOneWidget);

    await tester.enterText(field('Judul / peran'), 'Staff');
    await tester.enterText(field('Deskripsi'), '    ');
    await tester.enterText(field('URL gambar (opsional)'), 'foto.jpg');
    await tapSave(tester);
    expect(find.text('Deskripsi tidak boleh kosong!'), findsOneWidget);
    expect(find.textContaining('Masukkan URL yang valid'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
    expect(requests, isEmpty);
  });

  testWidgets('input valid dikirim lewat POST dengan token', (tester) async {
    final requests = <http.Request>[];
    await tester.pumpWidget(
      withProviders(
        fakeApi(requests: requests),
        const ExperienceFormPage(),
        token: 'abc123',
      ),
    );

    await fillValid(tester);
    await tester.enterText(
      field('URL gambar (opsional)'),
      'https://contoh.com/foto.jpg',
    );
    await tapSave(tester);

    final post = requests.single;
    expect(post.method, 'POST');
    expect(post.url.path, '/api/v1/experience/');
    expect(post.headers['Authorization'], 'Token abc123');
    expect(jsonDecode(post.body), {
      'title': 'Staff Pengmas BEM', // spasi dibuang
      'description': 'Mengajar anak-anak',
      'category': 'volunteer',
      'thumbnail': 'https://contoh.com/foto.jpg',
      'ended_at': null, // masih berjalan
    });

    expect(find.text('Experience berhasil disimpan!'), findsOneWidget);
    expect(find.text('Masih berjalan'), findsWidgets);

    await tester.tap(find.text('Tambah lagi'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Staff Pengmas BEM'), findsNothing); // form dikosongkan
    expect(find.text('Full-Time'), findsOneWidget); // kategori bawaan lagi
  });

  testWidgets('setelah simpan, Lihat daftar membuka daftar Experience', (
    tester,
  ) async {
    await tester.pumpWidget(
      withProviders(fakeApi(), const ExperienceFormPage(), token: 'abc123'),
    );
    await fillValid(tester);
    await tapSave(tester);

    await tester.tap(find.text('Lihat daftar'));
    await tester.pumpAndSettle();
    expect(find.byType(ExperienceListScreen), findsOneWidget);
    expect(find.byType(ExperienceFormPage), findsNothing);
  });

  testWidgets('401 menghapus sesi lalu meminta login ulang', (tester) async {
    await tester.pumpWidget(
      withProviders(
        fakeApi(writeStatus: 401),
        const ExperienceFormPage(),
        token: 'token-lama',
      ),
    );
    await fillValid(tester);
    await tapSave(tester);

    expect(find.text('Sesi berakhir, silakan login ulang.'), findsOneWidget);
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Experience berhasil disimpan!'), findsNothing);
  });

  testWidgets('403 menampilkan SnackBar dan tetap di form', (tester) async {
    await tester.pumpWidget(
      withProviders(
        fakeApi(writeStatus: 403),
        const ExperienceFormPage(),
        token: 'abc123',
      ),
    );
    await fillValid(tester);
    await tapSave(tester);

    expect(
      find.text('Hanya pemilik portofolio yang boleh menambah experience.'),
      findsOneWidget,
    );
    expect(find.byType(ExperienceFormPage), findsOneWidget);
  });

  testWidgets('tanggal selesai dipilih dari kalender dan ikut terkirim', (
    tester,
  ) async {
    final requests = <http.Request>[];
    await tester.pumpWidget(
      withProviders(
        fakeApi(requests: requests),
        const ExperienceFormPage(),
        token: 'abc123',
      ),
    );

    await tester.tap(field('Tanggal selesai (opsional)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK')); // pilih tanggal awal (hari ini)
    await tester.pumpAndSettle();
    expect(find.byTooltip('Hapus tanggal'), findsOneWidget);

    await fillValid(tester);
    await tapSave(tester);
    final now = DateTime.now();
    expect(
      (jsonDecode(requests.single.body) as Map)['ended_at'],
      DateTime.utc(now.year, now.month, now.day).toIso8601String(),
    );
  });

  testWidgets('di layar selebar ponsel tombol Simpan tetap bisa dijangkau', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      withProviders(fakeApi(), const ExperienceFormPage(), token: 'abc123'),
    );
    await tapSave(tester); // ensureVisible menggulir ke tombol
    expect(find.text('Judul tidak boleh kosong!'), findsOneWidget);
    expect(tester.takeException(), isNull); // tidak ada overflow
  });
}
