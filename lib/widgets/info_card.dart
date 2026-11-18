import 'package:material_ui/material_ui.dart';

/// Kartu kecil yang menampilkan satu informasi profil: [title] di atas dan
/// [content] di bawahnya.
///
/// Kartu ini tidak menentukan lebarnya sendiri. Lebar diatur oleh induknya
/// (lewat `Expanded` di `MyHomePage`), sehingga tiga kartu selalu berbagi
/// lebar layar sama rata dan tidak meluber di layar sempit.
class InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      // Bayangan tipis supaya kartu terlihat terangkat dari latar.
      elevation: 2.0,
      child: Padding(
        // Jarak samping dibuat kecil supaya NPM muat satu baris di layar ponsel.
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        // Judul dan isi disusun vertikal, di tengah kartu.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(content, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
