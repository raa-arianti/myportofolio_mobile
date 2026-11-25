import 'package:material_ui/material_ui.dart';

/// Data untuk satu tombol menu di halaman utama.
///
/// Warna dan halaman tujuan disimpan di sini, bersama nama dan ikon, supaya
/// [ItemCard] cukup membaca `item.color` dan `item.page` tanpa `if-else` per
/// tombol. Menambah tombol baru berarti menambah satu baris di daftar item,
/// bukan mengubah widget.
class ItemHomepage {
  /// Teks yang tampil di tombol dan di pesan SnackBar.
  final String name;

  /// Ikon yang tampil di atas teks.
  final IconData icon;

  /// Warna latar tombol, juga dipakai sebagai warna SnackBar-nya.
  final Color color;

  /// Halaman yang dibuka saat tombol ditekan, atau `null` kalau tombol ini
  /// hanya menampilkan SnackBar (halamannya belum dibuat).
  final Widget? page;

  /// `true` kalau [page] hanya boleh dibuka setelah login (lihat `ensureLoggedIn`).
  final bool requiresLogin;

  /// `true` untuk tombol Logout: menekannya mencabut token login.
  final bool isLogout;

  const ItemHomepage(
    this.name,
    this.icon,
    this.color, {
    this.page,
    this.requiresLogin = false,
    this.isLogout = false,
  });
}
