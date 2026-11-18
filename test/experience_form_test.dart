import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';

// Mengikuti "Petunjuk Pengujian" Tugas 8: buka form dari kartu dan drawer,
// simpan dengan input tidak valid lalu valid, dan kembali ke halaman utama.

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

void main() {
  testWidgets('kartu Tambah Experience membuka form, Back kembali ke menu', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(find.text('Tambah Experience'));
    await tester.tap(find.text('Tambah Experience'));
    await tester.pumpAndSettle();
    expect(find.byType(ExperienceFormPage), findsOneWidget);

    await tester.binding.handlePopRoute(); // tombol Back bawaan perangkat
    await tester.pumpAndSettle();
    expect(find.byType(MyHomePage), findsOneWidget);
  });

  testWidgets('drawer membuka form Experience, opsi Home kembali ke menu', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await openDrawer(tester);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Add Project'), findsOneWidget);
    await tester.tap(find.text('Add Experience'));
    await tester.pumpAndSettle();
    expect(find.byType(ExperienceFormPage), findsOneWidget);

    await openDrawer(tester); // drawer yang sama ada di halaman form
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.byType(MyHomePage), findsOneWidget);
    expect(find.byType(ExperienceFormPage), findsNothing);
  });

  testWidgets('input tidak valid ditolak dengan pesan di kolomnya', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ExperienceFormPage()));

    // Kosong semua.
    await tapSave(tester);
    expect(find.text('Judul tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);

    // Hanya spasi, judul terlalu panjang, dan URL tanpa http(s).
    await tester.enterText(field('Judul / peran'), 'a' * 256);
    await tester.enterText(field('Deskripsi'), '    ');
    await tester.enterText(field('URL gambar (opsional)'), 'foto.jpg');
    await tapSave(tester);
    expect(
      find.text('Judul maksimal 255 karakter.'),
      findsNothing,
    ); // maxLength memotong ketikan
    expect(find.text('Deskripsi tidak boleh kosong!'), findsOneWidget);
    expect(find.textContaining('Masukkan URL yang valid'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets(
    'input valid menampilkan ringkasan, OK menutup dan mengosongkan',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ExperienceFormPage()));

      await tester.enterText(field('Judul / peran'), '  Staff Pengmas BEM  ');
      await tester.enterText(field('Deskripsi'), 'Mengajar anak-anak');
      await tester.tap(find.text('Full-Time'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Volunteer').last);
      await tester.pumpAndSettle();
      await tester.enterText(
        field('URL gambar (opsional)'),
        'https://contoh.com/foto.jpg',
      );
      await tapSave(tester);

      expect(find.text('Experience berhasil disimpan!'), findsOneWidget);
      expect(find.text('Staff Pengmas BEM'), findsOneWidget); // spasi dibuang
      expect(find.text('Mengajar anak-anak'), findsWidgets);
      expect(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Volunteer'),
        ),
        findsOneWidget,
      );
      expect(find.text('Masih berjalan'), findsWidgets); // tanggal kosong

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('Staff Pengmas BEM'), findsNothing); // form dikosongkan
      expect(
        find.text('Full-Time'),
        findsOneWidget,
      ); // kategori kembali ke bawaan
    },
  );

  testWidgets('tanggal selesai dipilih dari kalender dan bisa dihapus', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ExperienceFormPage()));

    await tester.tap(field('Tanggal selesai (opsional)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK')); // pilih tanggal awal (hari ini)
    await tester.pumpAndSettle();
    expect(find.byTooltip('Hapus tanggal'), findsOneWidget);

    await tester.tap(find.byTooltip('Hapus tanggal'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Hapus tanggal'), findsNothing);
  });

  testWidgets('di layar selebar ponsel tombol Simpan tetap bisa dijangkau', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: ExperienceFormPage()));
    await tapSave(tester); // ensureVisible menggulir ke tombol
    expect(find.text('Judul tidak boleh kosong!'), findsOneWidget);
    expect(tester.takeException(), isNull); // tidak ada overflow
  });
}
