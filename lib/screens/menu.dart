import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/item_homepage.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/widgets/info_card.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

/// Halaman utama aplikasi: tiga kartu profil di atas, lalu kisi tombol menu.
///
/// Halaman ini `StatelessWidget` karena semua datanya tetap. Tidak ada nilai
/// yang berubah selama aplikasi berjalan, jadi tidak perlu `setState`.
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  final String npm = "2506551775";
  final String nama = "Ira Arianti Alawiah";
  final String kelas = "PBP D";

  /// Daftar tombol menu. Tiap item membawa nama, ikon, dan warnanya sendiri.
  final List<ItemHomepage> items = const [
    ItemHomepage("Lihat Proyek", Icons.folder, Colors.blue),
    ItemHomepage(
      "Tambah Proyek",
      Icons.add_circle,
      Colors.green,
      page: ProjectFormPage(),
    ),
    ItemHomepage("Lihat Experience", Icons.work, Colors.orange),
    ItemHomepage("Logout", Icons.logout, Colors.red),
  ];

  @override
  Widget build(BuildContext context) {
    // Di layar sempit (ponsel) tombol disusun 2 kolom, di layar lebar 4 kolom.
    final int columns = MediaQuery.sizeOf(context).width < 600 ? 2 : 4;

    // Scaffold menyediakan struktur dasar halaman (AppBar, body, tempat SnackBar).
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // Warna diambil dari tema yang dipasang MaterialApp di main.dart.
        backgroundColor: Theme.of(context).colorScheme.primary,
        // Ikon garis tiga (pembuka drawer) dibuat putih supaya terlihat.
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      // Bisa digulir, supaya isi tidak terpotong di layar pendek atau mode landscape.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          // Di layar lebar (web/desktop) isi dibatasi supaya tombol tidak raksasa.
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              children: [
                // IntrinsicHeight + stretch membuat ketiga kartu sama tinggi,
                // walaupun salah satu teksnya turun ke baris kedua.
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Expanded membagi lebar baris sama rata untuk tiga kartu.
                      Expanded(
                        child: InfoCard(title: 'NPM', content: npm),
                      ),
                      Expanded(
                        child: InfoCard(title: 'Name', content: nama),
                      ),
                      Expanded(
                        child: InfoCard(title: 'Class', content: kelas),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),
                const Text(
                  'Selamat datang di MyPortfolio Mobile!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                const SizedBox(height: 16.0),
                GridView.count(
                  crossAxisCount: columns,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  // Tinggi kisi mengikuti isinya, dan yang menggulir adalah
                  // halaman (SingleChildScrollView), bukan kisinya.
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  // Satu ItemCard untuk tiap item di daftar.
                  children: items.map((ItemHomepage item) {
                    return ItemCard(item);
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
