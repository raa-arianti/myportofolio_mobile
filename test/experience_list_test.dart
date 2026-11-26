import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/experience_detail_screen.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/experience_list_screen.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';

import 'fake_api.dart';

// Daftar dan detail Experience: data publik dari GET, kondisi loading,
// error + Retry, kosong, detail lengkap, dan hapus (DELETE) yang wajib login.

void main() {
  testWidgets('kartu Lihat Experience menampilkan data tanpa login', (
    tester,
  ) async {
    await tester.pumpWidget(MyApp(apiClient: fakeApi()));

    await tester.ensureVisible(find.text('Lihat Experience'));
    await tester.tap(find.text('Lihat Experience'));
    await tester.pumpAndSettle();
    expect(find.byType(ExperienceListScreen), findsOneWidget);
    expect(find.text('Staff Pengmas BEM'), findsOneWidget);
    expect(find.text('Volunteer'), findsOneWidget);
  });

  testWidgets('drawer View Experience membuka daftar', (tester) async {
    await tester.pumpWidget(MyApp(apiClient: fakeApi()));

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('View Experience'));
    await tester.pumpAndSettle();
    expect(find.byType(ExperienceListScreen), findsOneWidget);
  });

  testWidgets('daftar kosong menampilkan pesan', (tester) async {
    await tester.pumpWidget(
      withProviders(fakeApi(experiences: []), const ExperienceListScreen()),
    );
    // Frame pertama: data belum datang, jadi indikator loading tampil.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('Belum ada experience.'), findsOneWidget);
  });

  testWidgets('error menampilkan tombol Retry yang memuat ulang', (
    tester,
  ) async {
    final requests = <http.Request>[];
    await tester.pumpWidget(
      withProviders(
        fakeApi(requests: requests, listStatus: 500),
        const ExperienceListScreen(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Gagal memuat experience'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(requests.length, 2);
  });

  testWidgets('mengetuk item membuka detail dengan semua field', (
    tester,
  ) async {
    await tester.pumpWidget(
      withProviders(fakeApi(), const ExperienceListScreen()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Staff Pengmas BEM'));
    await tester.pumpAndSettle();
    expect(find.byType(ExperienceDetailScreen), findsOneWidget);
    for (final text in [
      'Staff Pengmas BEM',
      'Mengajar anak-anak',
      'Volunteer',
      'Sudah selesai',
      'Jan 10, 2026',
      'Jun 30, 2026',
      '3',
      'ani, budi, citra',
    ]) {
      expect(find.text(text), findsOneWidget, reason: text);
    }
  });

  testWidgets('tombol + di daftar meminta login lalu membuka form', (
    tester,
  ) async {
    await tester.pumpWidget(
      withProviders(fakeApi(), const ExperienceListScreen()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Tambah Experience'));
    await tester.pumpAndSettle();
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
    expect(find.byType(ExperienceFormPage), findsOneWidget);
  });

  testWidgets('hapus dari detail mengirim DELETE dan memuat ulang daftar', (
    tester,
  ) async {
    final requests = <http.Request>[];
    await tester.pumpWidget(
      withProviders(
        fakeApi(requests: requests),
        const ExperienceListScreen(),
        token: 'abc123',
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Staff Pengmas BEM'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Hapus'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Hapus'));
    await tester.pumpAndSettle();

    final delete = requests.firstWhere((r) => r.method == 'DELETE');
    expect(delete.url.path, '/api/v1/experience/exp-1/');
    expect(delete.headers['Authorization'], 'Token abc123');
    expect(find.byType(ExperienceListScreen), findsOneWidget);
    expect(requests.where((r) => r.method == 'GET').length, 2);
  });

  testWidgets('hapus ditolak 403 menampilkan pesan dan tetap di detail', (
    tester,
  ) async {
    await tester.pumpWidget(
      withProviders(
        fakeApi(writeStatus: 403),
        const ExperienceListScreen(),
        token: 'abc123',
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Staff Pengmas BEM'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Hapus'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Hapus'));
    await tester.pumpAndSettle();

    expect(
      find.text('Hanya pemilik portofolio yang boleh menghapus.'),
      findsOneWidget,
    );
    expect(find.byType(ExperienceDetailScreen), findsOneWidget);
  });
}
