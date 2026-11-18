import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/item_homepage.dart';

/// Tombol menu berbentuk kartu. Saat ditekan, muncul SnackBar berisi nama
/// tombolnya, lalu halaman tujuannya ([ItemHomepage.page]) dibuka kalau ada.
class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  // Sudut kartu dan sudut efek riak (ripple) harus sama supaya riaknya tidak
  // keluar dari sudut yang membulat.
  static final BorderRadius _radius = BorderRadius.circular(12);

  /// Menampilkan SnackBar untuk tombol ini.
  ///
  /// SnackBar yang sedang tampil disembunyikan dulu, supaya menekan beberapa
  /// tombol berturut-turut tidak membuat pesan lama mengantre.
  void _showPressedMessage(BuildContext context) {
    // ScaffoldMessenger dicari lewat context: ia berada di atas widget ini di
    // widget tree, dipasang oleh MaterialApp.
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text("Kamu telah menekan tombol ${item.name}!"),
          // Warna SnackBar mengikuti warna tombol yang ditekan.
          backgroundColor: item.color,
          // SnackBar yang punya action secara bawaan tidak hilang sendiri.
          // persist: false membuatnya tetap hilang otomatis setelah beberapa
          // detik, dan tombol "Tutup" tetap bisa dipakai untuk menutup lebih cepat.
          persist: false,
          action: SnackBarAction(
            label: 'Tutup',
            textColor: Colors.white,
            onPressed: messenger.hideCurrentSnackBar,
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      // Warna latar diambil dari data item, jadi tiap tombol punya warnanya sendiri.
      color: item.color,
      borderRadius: _radius,
      child: InkWell(
        borderRadius: _radius,
        onTap: () {
          _showPressedMessage(context);
          // push: halaman tujuan ditumpuk di atas menu, jadi tombol Back
          // bawaan perangkat membawa pengguna kembali ke menu.
          final page = item.page;
          if (page != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, color: Colors.white, size: 30.0),
              const SizedBox(height: 6),
              Text(
                item.name,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
