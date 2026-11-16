import 'package:flutter/material.dart';

/// Data untuk satu tombol menu di halaman utama.
///
/// Warna disimpan di sini, bersama nama dan ikon, supaya [ItemCard] cukup
/// membaca `item.color` tanpa perlu `if-else` per tombol. Menambah tombol baru
/// berarti menambah satu baris di daftar item, bukan mengubah widget.
class ItemHomepage {
  /// Teks yang tampil di tombol dan di pesan SnackBar.
  final String name;

  /// Ikon yang tampil di atas teks.
  final IconData icon;

  /// Warna latar tombol, juga dipakai sebagai warna SnackBar-nya.
  final Color color;

  const ItemHomepage(this.name, this.icon, this.color);
}
