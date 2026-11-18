# My Portofolio Mobile

Aplikasi mobile portofolio pribadi yang dibangun dengan Flutter. Proyek ini adalah
pasangan dari [website portofolio saya](https://github.com/raa-arianti/myportofolio)
dan dikembangkan secara bertahap sepanjang mata kuliah **Pemrograman Berbasis
Platform (CSGE602022)**, Fakultas Ilmu Komputer, Universitas Indonesia,
Semester Gasal 2026/2027.

| | |
|---|---|
| **Nama** | Ira Arianti Alawiah |
| **NPM** | 2506551775 |
| **Kelas** | PBP D |

- **Repositori:** https://github.com/raa-arianti/myportofolio_mobile
- **Repositori web (Django):** https://github.com/raa-arianti/myportofolio

---

## Tentang Proyek

Sampai Tugas 8, aplikasi terdiri atas tiga halaman:

**Halaman utama** (`MyHomePage`)

- **Tiga kartu profil** (`InfoCard`) di bagian atas: NPM, nama, dan kelas.
- **Lima tombol menu** (`ItemCard`): Lihat Proyek, Tambah Proyek, Lihat Experience,
  Tambah Experience, dan Logout. Tiap tombol punya ikon dan warna latarnya sendiri.
- **SnackBar** yang muncul saat tombol ditekan, berisi
  "Kamu telah menekan tombol [Nama Tombol]!". Warnanya mengikuti tombol yang ditekan
  dan ada tombol **Tutup** untuk menutupnya lebih cepat.
- Tombol **Tambah Proyek** dan **Tambah Experience** membuka form-nya dengan
  `Navigator.push()`, jadi tombol Back perangkat kembali ke halaman utama.

**Form Tambah Proyek** (`ProjectFormPage`, Tutorial 09) dan **form Tambah Experience**
(`ExperienceFormPage`, Tugas 8)

- Setiap kolom divalidasi. Tombol Simpan menampilkan ringkasan isian dalam dialog
  hanya jika semua isian valid. Tombol OK menutup dialog dan mengosongkan form.
- Field form Experience mengikuti model `Experience` di website: judul (wajib,
  maksimal 255 karakter), deskripsi (wajib), kategori (dropdown), URL gambar
  (opsional, harus `http(s)://`), dan tanggal selesai (opsional, dipilih dari kalender;
  kosong berarti masih berjalan).

**Navigasi dan tampilan**

- **Drawer** (`LeftDrawer`) dengan opsi Home, Add Project, dan Add Experience, dipasang
  di ketiga halaman.
- **Tema** aplikasi memakai warna aksen yang sama dengan website portofolio (`#A05A76`):
  AppBar, header drawer, dan tombol Simpan semuanya mengambil warna dari tema.
- **Tata letak responsif**: tombol menu tersusun 2 kolom di layar ponsel dan 4 kolom di
  layar lebar, dan semua halaman bisa digulir sehingga tombol Simpan tetap terjangkau
  di layar pendek atau saat papan ketik muncul.

Data form belum disimpan ke database. Pengiriman ke API Django akan ditambahkan pada
minggu-minggu berikutnya.

## Teknologi

| | |
|---|---|
| Framework | Flutter 3.47.5 (channel stable) |
| Bahasa | Dart (SDK `^3.13.4`) |
| Desain | Material 3, lewat paket `material_ui` |
| Aturan lint | `flutter_lints` |

## Struktur Proyek

```
lib/
├── main.dart                   # titik masuk: runApp, MaterialApp, dan tema
├── models/
│   └── item_homepage.dart      # ItemHomepage: nama, ikon, warna, dan halaman tujuan tombol
├── screens/
│   ├── menu.dart               # MyHomePage, halaman utama
│   ├── project_form.dart       # ProjectFormPage, form Tambah Proyek (Tutorial 09)
│   └── experience_form.dart    # ExperienceFormPage, form Tambah Experience (Tugas 8)
└── widgets/
    ├── info_card.dart          # InfoCard, kartu profil
    ├── left_drawer.dart        # LeftDrawer, menu navigasi samping
    └── project_card.dart       # ItemCard, tombol menu, SnackBar, dan navigasinya
test/
├── widget_test.dart            # halaman utama, drawer, dan form proyek
└── experience_form_test.dart   # form Experience
```

Folder `android/`, `ios/`, `web/`, `windows/`, `linux/`, dan `macos/` dibuat oleh
`flutter create` dan berisi pembungkus untuk tiap platform.

## Menjalankan Secara Lokal

Prasyarat: Flutter SDK sudah terpasang dan `flutter` ada di PATH.

```bash
# 1. Klon repositori
git clone https://github.com/raa-arianti/myportofolio_mobile.git
cd myportofolio_mobile

# 2. Unduh dependencies
flutter pub get

# 3. Jalankan aplikasi (contoh: di Chrome)
flutter run -d chrome

# 4. Periksa kualitas kode dan jalankan test
flutter analyze
flutter test
```

Hasil terakhir (Tugas 8): `flutter analyze` menampilkan `No issues found!` dan 13 test
lulus.

---

## Progres Mingguan

### Tutorial 08, Basic Flutter

- Membuat proyek dengan `flutter create myportofolio_mobile`.
- Memisahkan halaman utama ke `lib/menu.dart`, terpisah dari `lib/main.dart`.
- Mengubah `MyHomePage` menjadi `StatelessWidget`.
- Menyusun `InfoCard` dan `ItemCard` dengan data contoh (Burhan), serta SnackBar
  saat tombol ditekan.

### Tugas 7, Halaman utama portofolio pribadi

- Mengganti data contoh di tiga `InfoCard` dengan identitas saya sendiri.
- Menambahkan atribut `color` pada model `ItemHomepage` sehingga tiap tombol punya
  warna latar sendiri tanpa percabangan `if-else` di `ItemCard`.
- Mengganti warna dasar tema menjadi `#A05A76`, warna aksen website portofolio.
- Menambahkan tombol keempat, **Lihat Experience**, sesuai bagian Experience di website.
- Membuat SnackBar berwarna sesuai tombol dan memberi tombol **Tutup**.
- Membuat tata letak responsif: `InfoCard` berbagi lebar dengan `Expanded`, kisi
  tombol 2 atau 4 kolom, dan halaman bisa digulir.
- Memisahkan `ItemHomepage`, `InfoCard`, dan `ItemCard` ke berkas masing-masing.
- Mengganti test bawaan yang sudah usang dengan 4 test untuk halaman utama.

### Tutorial 09, Navigation, Layouts, Forms, and Input Elements

- Memasang paket `material_ui` dan mengganti semua import `flutter/material.dart`.
- Membuat `LeftDrawer` dengan opsi Home dan Add Project.
- Membuat `ProjectFormPage` dengan `Form`, `GlobalKey<FormState>`, validasi, dan
  dialog ringkasan isian.
- Membuat tombol **Tambah Proyek** membuka form dengan `Navigator.push()`.
- Memindahkan halaman ke `lib/screens/` dan `ItemCard` ke `widgets/project_card.dart`.

### Tugas 8, Form Experience

- Menyimpan halaman tujuan tiap tombol di `ItemHomepage.page`, sehingga `ItemCard`
  tidak perlu lagi memeriksa nama tombol dengan `if`.
- Membuat `ExperienceFormPage` dengan field dan aturan validasi yang sama dengan model
  dan form `Experience` di website Django.
- Menambahkan kartu **Tambah Experience** di halaman utama dan opsi **Add Experience**
  di drawer.
- Fitur tambahan di luar checklist:
  - pemilih tanggal (`showDatePicker`) untuk tanggal selesai, dengan tombol hapus
    tanggal dan penolakan tanggal di masa depan;
  - validasi format URL dan penghitung karakter judul (`maxLength`);
  - papan ketik yang sesuai jenis isian (`TextInputType.url`, `multiline`) dan tombol
    Next di papan ketik;
  - validasi ulang otomatis saat kolom diperbaiki (`AutovalidateMode.onUserInteraction`);
  - form dibatasi lebar 600 piksel di layar lebar.
- Menambahkan 6 test untuk form Experience: dibuka dari kartu dan drawer, kembali ke
  Home, input tidak valid dan valid, kalender, dan layar selebar ponsel.

---

## Pertanyaan Reflektif

### Tugas 7

1. **Jelaskan apa yang dimaksud dengan widget tree pada Flutter dan bagaimana hubungan
   induk-anak (parent-child) bekerja antar-widget!**

   Di Flutter, seluruh tampilan disusun dari widget yang saling bersarang. Susunan
   bersarang itu membentuk struktur pohon yang disebut **widget tree**. Akarnya adalah
   widget yang diberikan ke `runApp`, lalu bercabang ke bawah sampai ke widget paling
   kecil seperti `Text` dan `Icon`.

   Di proyek ini, pohonnya kurang lebih seperti ini:

   ```
   MyApp
   └── MaterialApp
       └── MyHomePage
           └── Scaffold
               ├── AppBar
               │   └── Text
               └── SingleChildScrollView
                   └── Center
                       └── ConstrainedBox
                           └── Column
                               ├── IntrinsicHeight
                               │   └── Row
                               │       └── Expanded (x3)
                               │           └── InfoCard
                               ├── Text
                               └── GridView
                                   └── ItemCard (x4)
   ```

   Hubungan induk-anak bekerja dalam tiga hal:

   - **Induk menentukan anak.** Widget induk menerima anaknya lewat properti `child`
     (satu anak, misalnya `Padding`) atau `children` (banyak anak, misalnya `Column`).
   - **Data mengalir dari induk ke anak lewat konstruktor.** `MyHomePage` menyimpan
     `npm`, lalu mengopernya dengan `InfoCard(title: 'NPM', content: npm)`. `InfoCard`
     tinggal menampilkan `content` yang ia terima. Anak tidak mengubah data induknya.
   - **Induk mengatur ukuran dan posisi anak.** Induk memberi batasan ukuran
     (constraints) ke anak, anak memilih ukurannya dalam batasan itu, lalu induk
     menentukan posisinya. Contohnya, `InfoCard` tidak menentukan lebarnya sendiri.
     `Expanded` di dalam `Row` yang membagi lebar baris sama rata untuk ketiganya.

   Selain itu, anak bisa mengambil sesuatu dari leluhur yang jauh di atasnya lewat
   `BuildContext`, misalnya `Theme.of(context)`.

2. **Sebutkan semua widget yang kamu gunakan dalam proyek ini dan jelaskan fungsinya
   masing-masing!**

   Widget buatan sendiri:

   | Widget | Fungsi |
   |---|---|
   | `MyApp` | Widget akar. Memasang `MaterialApp`, tema, dan halaman awal. |
   | `MyHomePage` | Halaman utama. Menyusun kartu profil dan kisi tombol. |
   | `InfoCard` | Kartu kecil berisi satu informasi profil (judul dan isi). |
   | `ItemCard` | Tombol menu berbentuk kartu yang memunculkan SnackBar saat ditekan. |

   Widget bawaan Flutter:

   | Widget | Fungsi |
   |---|---|
   | `MaterialApp` | Membungkus aplikasi dengan Material Design: tema, navigasi, judul. |
   | `Scaffold` | Kerangka satu halaman: tempat `AppBar`, `body`, dan SnackBar. |
   | `AppBar` | Bar di bagian atas halaman yang berisi judul aplikasi. |
   | `Text` | Menampilkan teks. |
   | `Icon` | Menampilkan ikon dari kumpulan `Icons`. |
   | `SingleChildScrollView` | Membuat isi halaman bisa digulir jika lebih tinggi dari layar. |
   | `Center` | Menempatkan anaknya di tengah. |
   | `ConstrainedBox` | Membatasi ukuran anaknya, di sini lebar maksimal 720 piksel. |
   | `Column` | Menyusun anak-anaknya secara vertikal. |
   | `Row` | Menyusun anak-anaknya secara horizontal. |
   | `Expanded` | Membuat anak mengisi sisa ruang di `Row`/`Column`, dibagi rata antar-`Expanded`. |
   | `IntrinsicHeight` | Menyamakan tinggi anak-anak `Row` dengan anak yang paling tinggi. |
   | `SizedBox` | Kotak kosong berukuran tetap, dipakai sebagai jarak antar-widget. |
   | `Padding` | Memberi jarak di sekeliling anaknya. |
   | `Card` | Kotak dengan sudut membulat dan bayangan, dipakai `InfoCard`. |
   | `GridView` (`GridView.count`) | Menyusun anak dalam kisi dengan jumlah kolom tertentu. |
   | `Material` | Permukaan Material yang memberi warna latar dan sudut membulat pada tombol. |
   | `InkWell` | Membuat area bisa ditekan dan menampilkan efek riak (ripple). |
   | `SnackBar` | Pesan singkat yang muncul sementara di bawah layar. |
   | `SnackBarAction` | Tombol di dalam SnackBar, di sini tombol "Tutup". |

   Ada juga tiga widget yang tidak saya tulis langsung di pohon, tetapi saya akses
   lewat `context`: `Theme` (`Theme.of(context)` untuk warna tema), `MediaQuery`
   (`MediaQuery.sizeOf(context)` untuk lebar layar), dan `ScaffoldMessenger`
   (`ScaffoldMessenger.of(context)` untuk menampilkan SnackBar). Ketiganya dipasang
   otomatis oleh `MaterialApp`.

3. **Apa fungsi dari widget `MaterialApp`? Jelaskan mengapa widget ini umumnya digunakan
   sebagai root widget pada aplikasi Flutter!**

   `MaterialApp` menyiapkan semua hal yang dibutuhkan aplikasi bergaya Material Design:

   - **Tema** (`theme`): warna dan gaya teks yang berlaku untuk seluruh aplikasi. Di
     proyek ini temanya dibuat dari satu warna dasar dengan
     `ColorScheme.fromSeed(seedColor: Color(0xFFA05A76))`.
   - **Navigasi**: menyediakan `Navigator` untuk berpindah halaman, dan menentukan
     halaman awal lewat `home`.
   - **Layanan untuk widget di bawahnya**: `MediaQuery` (ukuran layar),
     `ScaffoldMessenger` (SnackBar), arah teks, dan lokalisasi.
   - **Judul aplikasi** (`title`) yang dipakai sistem operasi atau tab browser.

   `MaterialApp` dipakai sebagai root karena widget hanya bisa mengambil sesuatu dari
   **leluhurnya** di widget tree. Jika `MaterialApp` berada di paling atas, semua
   widget di bawahnya bisa memanggil `Theme.of(context)`, `MediaQuery.of(context)`,
   dan `ScaffoldMessenger.of(context)`. Tanpa `MaterialApp` di atasnya, widget seperti
   `Scaffold`, `AppBar`, dan `SnackBar` tidak punya tema maupun layanan yang mereka
   butuhkan dan akan error. Contoh nyatanya: saya hanya mengganti `seedColor` di
   `main.dart`, dan warna `AppBar` di `menu.dart` ikut berubah tanpa disentuh.

4. **Jelaskan perbedaan antara `StatelessWidget` dan `StatefulWidget`! Kapan kita
   sebaiknya memilih `StatelessWidget` dan kapan harus menggunakan `StatefulWidget`?**

   | | `StatelessWidget` | `StatefulWidget` |
   |---|---|---|
   | Data | Tetap. Semua field `final` dan ditetapkan saat widget dibuat. | Punya data yang bisa berubah selama widget hidup, disimpan di objek `State`. |
   | Struktur | Satu kelas dengan metode `build`. | Dua kelas: widget-nya dan `State`-nya. `build` ada di `State`. |
   | Menggambar ulang | Hanya ketika induknya membuat ulang widget ini dengan data baru. | Juga ketika `setState()` dipanggil dari dalam. |
   | Lifecycle | Tidak ada. | Ada `initState`, `dispose`, dan lainnya. |

   Pilih **`StatelessWidget`** jika tampilan hanya bergantung pada data yang diterima
   dari konstruktor dan tidak berubah karena interaksi di dalam widget itu sendiri.
   Semua widget di proyek ini seperti itu. `MyHomePage` menampilkan NPM, nama, kelas,
   dan daftar tombol yang tidak pernah berubah, jadi semuanya `final` dan
   konstruktornya bisa `const`. Menekan tombol memang memunculkan SnackBar, tetapi
   SnackBar dikelola oleh `ScaffoldMessenger`, bukan oleh data di `MyHomePage`.

   Pilih **`StatefulWidget`** jika ada nilai yang berubah dan tampilannya harus ikut
   berubah, misalnya penghitung, isi form, kotak centang, tab yang sedang dipilih,
   atau data yang dimuat dari internet. Contoh di proyek ini nanti: halaman daftar
   proyek yang mengambil data dari API Django perlu menyimpan status "sedang memuat"
   dan hasilnya.

   Aturan praktisnya: mulai dari `StatelessWidget`, dan ganti ke `StatefulWidget`
   hanya ketika benar-benar butuh `setState`. `StatelessWidget` lebih sederhana dan
   lebih mudah diuji.

5. **Apa itu `BuildContext` dan mengapa penting di Flutter? Bagaimana penggunaannya di
   dalam metode `build`?**

   `BuildContext` adalah penanda **posisi sebuah widget di dalam widget tree**. Setiap
   widget mendapat `context`-nya sendiri sebagai parameter metode `build`.

   `BuildContext` penting karena lewat posisi itulah sebuah widget bisa mencari
   leluhurnya. Pemanggilan berbentuk `Sesuatu.of(context)` berarti "naik dari posisi
   saya di pohon dan temukan `Sesuatu` yang terdekat". Dengan cara ini data bersama
   seperti tema dan ukuran layar tidak perlu dioper satu per satu lewat konstruktor.

   Penggunaannya di proyek ini:

   - `Theme.of(context).colorScheme.primary` di `MyHomePage`, untuk mengambil warna
     `AppBar` dari tema yang dipasang `MaterialApp`.
   - `MediaQuery.sizeOf(context).width` di `MyHomePage`, untuk mengetahui lebar layar
     dan memilih 2 atau 4 kolom tombol.
   - `ScaffoldMessenger.of(context)` di `ItemCard`, untuk menampilkan SnackBar.

   Hal yang perlu diperhatikan: `context` hanya bisa menemukan widget yang berada **di
   atasnya**. Karena itu `context` yang dipakai harus berasal dari widget yang
   posisinya memang di bawah widget yang dicari.

6. **Jelaskan konsep hot reload di Flutter dan apa perbedaannya dengan hot restart!
   Kapan kita tidak bisa hanya mengandalkan hot reload dan harus melakukan hot restart
   atau full restart?**

   **Hot reload** menyuntikkan kode Dart yang baru diubah ke aplikasi yang sedang
   berjalan, lalu Flutter membangun ulang widget tree. Aplikasi tidak dimulai dari
   awal, sehingga **state tetap terjaga** (misalnya isi form atau halaman yang sedang
   dibuka) dan perubahan terlihat dalam hitungan detik. Di terminal `flutter run`,
   hot reload dijalankan dengan tombol `r`.

   **Hot restart** memuat ulang seluruh kode Dart dan menjalankan aplikasi dari awal,
   mulai dari `main()`. **State hilang**, tetapi aplikasi tidak perlu dikompilasi
   ulang seluruhnya, jadi tetap lebih cepat daripada menghentikan dan menjalankan
   lagi. Tombolnya `R` (huruf besar).

   | | Hot reload | Hot restart | Full restart |
   |---|---|---|---|
   | State aplikasi | Terjaga | Hilang | Hilang |
   | `main()` dijalankan lagi | Tidak | Ya | Ya |
   | Kode native dikompilasi ulang | Tidak | Tidak | Ya |
   | Kecepatan | Paling cepat | Cepat | Paling lambat |

   Hot reload **tidak cukup**, dan perlu hot restart, ketika perubahan ada di kode
   yang hanya dijalankan sekali saat aplikasi mulai:

   - isi `main()` atau `initState()`;
   - nilai awal variabel global dan field `static`;
   - perubahan besar pada bentuk kelas, misalnya mengubah `enum` menjadi kelas biasa
     atau mengubah tipe generik.

   **Full restart** (hentikan aplikasi, lalu `flutter run` lagi) diperlukan ketika
   perubahannya di luar kode Dart:

   - menambah atau mengubah dependencies di `pubspec.yaml`;
   - menambah aset seperti gambar atau font;
   - mengubah kode atau konfigurasi native di folder `android/`, `ios/`, dan
     sejenisnya (misalnya izin aplikasi atau ikon).

   Contoh dari pengerjaan tugas ini: mengganti warna tombol dan teks di `menu.dart`
   langsung terlihat dengan hot reload, karena perubahan itu ada di dalam widget yang
   dibangun ulang.

### Tugas 8

1. **Perbedaan `Navigator.push()`, `Navigator.pushReplacement()`, dan `Navigator.pop()`;
   metode untuk kartu aksi; dan cara opsi Home kembali ke halaman utama.**

   `Navigator` menyimpan halaman-halaman (route) sebagai tumpukan (stack). Halaman yang
   tampil adalah yang paling atas.

   | Metode | Yang terjadi pada tumpukan | Tombol Back setelahnya |
   |---|---|---|
   | `push()` | Halaman baru ditaruh di atas halaman sekarang. | Kembali ke halaman sebelumnya. |
   | `pushReplacement()` | Halaman paling atas dibuang, lalu diganti halaman baru. | Tidak kembali ke halaman yang dibuang. |
   | `pop()` | Halaman paling atas dibuang, sehingga halaman di bawahnya tampil. | (Ini sendiri adalah aksi "kembali".) |

   Kartu aksi **Tambah Experience** memakai `Navigator.push()` (di `ItemCard`, berkas
   `widgets/project_card.dart`). Tumpukannya menjadi `[Menu, Form Experience]`, sehingga
   tombol Back perangkat atau browser menjalankan `pop()` dan pengguna kembali ke menu.
   `pop()` juga dipakai untuk menutup dialog ringkasan, karena dialog juga sebuah route.

   Opsi di drawer memakai `Navigator.pushReplacement()`. Saat pengguna berada di form
   Experience dan memilih **Home**, route form diganti dengan route `MyHomePage` baru,
   jadi form tidak tertinggal di tumpukan. Ini mencegah tumpukan terus bertambah saat
   pengguna berpindah-pindah lewat drawer, dan mencegah tombol Back membuka lagi form
   yang sudah ditinggalkan.

2. **Peran `Scaffold`, `AppBar`, dan `Drawer` dalam menjaga struktur halaman tetap
   konsisten, dan contoh warna tema di lebih dari satu halaman.**

   `Scaffold` adalah kerangka yang sama untuk setiap halaman: slot `appBar` di atas,
   `drawer` di samping, dan `body` di tengah. Karena ketiga halaman (menu, form proyek,
   form Experience) memakai kerangka itu, pengguna selalu menemukan judul di tempat yang
   sama dan ikon menu ☰ di pojok kiri atas. `Scaffold` juga yang otomatis menampilkan
   ikon ☰ saat `drawer` diisi.

   `AppBar` memberi judul halaman, sehingga pengguna tahu sedang berada di mana.
   `Drawer` diisi widget yang sama, `const LeftDrawer()`, di ketiga halaman. Isi navigasi
   cukup ditulis sekali di `widgets/left_drawer.dart`. Saat opsi Add Experience
   ditambahkan, opsi itu langsung muncul di semua halaman.

   Contoh warna tema: warna aksen website `#A05A76` dipasang sekali di `main.dart`
   (`ColorScheme.fromSeed`). Halaman lain tidak menulis kode warna sendiri, tetapi
   mengambilnya dengan `Theme.of(context).colorScheme.primary`. Warna itu dipakai
   `AppBar` di halaman utama, form proyek, dan form Experience, juga header drawer.
   Tombol `FilledButton` Simpan di form Experience mengambil warna yang sama secara
   otomatis dari tema.

3. **Alasan tata letak form dipilih, serta peran widget pengatur jarak dan widget
   penggulir saat ruang layar terbatas.**

   Form Experience disusun dalam satu `Column`: satu kolom isian per baris, dari atas ke
   bawah, dengan tombol Simpan di paling bawah. Susunan satu kolom paling mudah dibaca
   di layar ponsel yang sempit, dan urutannya sama dengan urutan pengisian. Saya memakai
   `CrossAxisAlignment.stretch` agar semua kolom selebar layar dan rata kiri-kanan.

   Widget pengatur jarak:
   - `Padding` (lewat `SingleChildScrollView.padding`) memberi jarak 16 piksel dari tepi
     layar, agar isian tidak menempel di pinggir.
   - `SizedBox(height: ...)` memberi jarak antar-kolom. Jaraknya sedikit lebih besar
     sebelum tombol Simpan, untuk memisahkan isian dari aksi.
   - `ConstrainedBox(maxWidth: 600)` dan `Center` membatasi lebar form di layar lebar
     (web/tablet), agar kolom isian tidak melebar sampai ke tepi.

   Widget penggulir: `Column` tidak bisa digulir sendiri. Saat papan ketik muncul,
   `Scaffold` memperkecil ruang `body`, sehingga form bisa lebih tinggi dari ruang yang
   tersisa. `SingleChildScrollView` membuat seluruh form bisa digulir, jadi kolom
   terbawah dan tombol Simpan tetap bisa dijangkau dan tidak terjadi *overflow*
   (garis kuning-hitam). `SafeArea` menjaga isi tidak tertutup notch atau bilah sistem.
   Hal ini diuji di `experience_form_test.dart` dengan layar 360×640.

4. **Peran `GlobalKey<FormState>`, `validator`, dan `validate()` saat Simpan ditekan;
   contoh nilai yang ditolak; dan mengapa jenis input atau papan ketik saja belum
   cukup.**

   - `GlobalKey<FormState>` (`_formKey`) adalah "pegangan" ke state widget `Form`. Lewat
     `_formKey.currentState`, tombol Simpan (yang letaknya di luar setiap kolom) bisa
     memerintah seluruh form sekaligus, misalnya `validate()` atau `reset()`.
   - `validator` adalah fungsi aturan di setiap `TextFormField`. Fungsi ini mengembalikan
     `null` jika isian valid, atau teks pesan error jika tidak.
   - `validate()` menjalankan `validator` semua kolom di dalam `Form`, menampilkan pesan
     error di bawah kolom yang salah, lalu mengembalikan `true` hanya jika semuanya valid.
     Di `_save()`, dialog ringkasan baru dipanggil jika `validate()` bernilai `true`.

   Contoh nilai yang ditolak: deskripsi yang diisi `"     "` (hanya spasi). Kolomnya
   tidak kosong, tetapi `_required` memeriksa `value.trim().isEmpty`, sehingga muncul
   "Deskripsi tidak boleh kosong!". Contoh lain: URL gambar `foto.jpg` ditolak karena
   tidak diawali `http://` atau `https://`.

   Jenis input dan papan ketik saja tidak cukup, karena keduanya hanya **membantu**
   pengguna mengetik, bukan **membatasi** isian. `TextInputType.url` hanya menampilkan
   papan ketik yang punya tombol `/` dan `.com`; pengguna tetap bisa mengetik `foto.jpg`,
   spasi, atau menempelkan teks apa pun. Di web dan desktop, papan ketik fisik
   mengabaikan pengaturan ini sama sekali. Aturan yang sebenarnya, yaitu wajib diisi,
   bukan hanya spasi, format URL, dan tanggal tidak di masa depan, tetap harus dicek oleh
   `validator`. Nantinya aturan yang sama juga dicek lagi oleh Django di server, karena
   data bisa saja dikirim tanpa melewati aplikasi.

---

## Penggunaan AI (AI Disclosure)

### Tugas 7

#### Tools

**Claude (model Fable 5.2) melalui Claude Code** di aplikasi desktop, 16 November 2026.

#### Strategi Penggunaan AI

Dalam pengerjaan Tugas 7, saya menggunakan AI sebagai alat bantu untuk memahami konsep Flutter, memperoleh referensi implementasi, serta membantu proses pemeriksaan kode.

Saya memulai dengan memberikan instruksi tugas dan kode proyek hasil Tutorial 08 agar AI dapat membantu mengidentifikasi kebutuhan pengembangan aplikasi. Selanjutnya, saya menggunakan pendekatan bertahap dengan mempelajari fungsi setiap berkas, memahami konsep widget, serta mendiskusikan implementasi fitur yang diperlukan.

Penggunaan AI difokuskan pada beberapa aktivitas:

* Memahami struktur proyek dan hubungan antar-widget dalam Flutter.
* Mendiskusikan pendekatan implementasi fitur berdasarkan kebutuhan tugas.
* Memperoleh contoh kode untuk memahami penggunaan komponen dan properti Flutter.
* Membantu mengidentifikasi kesalahan serta memberikan alternatif penyelesaian.
* Memeriksa hasil implementasi melalui analisis kode dan pengujian.

Bagian wajib tugas saya kerjakan sendiri dengan panduan AI. Setelah bagian wajib selesai, fitur tambahan saya delegasikan kepada AI.
Saya tetap melakukan penyesuaian terhadap implementasi berdasarkan kebutuhan aplikasi portofolio yang sedang dikembangkan.

#### Bagian yang Dibantu AI

1. Pemahaman konsep dan struktur proyek
   * Menjelaskan struktur folder Flutter dan fungsi masing-masing berkas.
   * Menjelaskan konsep `StatelessWidget`, widget tree, dan hubungan parent-child.
   * Memberikan penjelasan mengenai penggunaan `BuildContext`, `Theme`, dan `MediaQuery`.
   * Membantu memahami penggunaan `ColorScheme.fromSeed` dan konfigurasi tema aplikasi.
2. Implementasi
   * Memberikan contoh implementasi model `ItemHomepage` dan penggunaan atribut warna pada komponen.
   * Menulis fitur tambahan: tombol Lihat Experience, SnackBar berwarna dengan tombol Tutup, dan tata letak responsif.
   * Memisahkan `ItemHomepage`, `InfoCard`, dan `ItemCard` ke berkas masing-masing serta menambahkan komentar dokumentasi.
   * Menulis widget test untuk halaman utama.
3. Pemeriksaan dan debugging
   * Membantu menganalisis pesan kesalahan yang muncul selama pengembangan.
   * Memberikan saran perbaikan terhadap konfigurasi proyek dan dependensi.
   * Membantu memeriksa hasil `flutter analyze` dan `flutter test`.
   * Memberikan masukan terhadap tampilan aplikasi pada ukuran layar yang berbeda.
4. Dokumentasi
   * Menyusun draf README, termasuk draf jawaban pertanyaan reflektif, berdasarkan implementasi proyek.

#### Bagian yang Saya Kerjakan dan Bertanggung Jawab

* Menentukan pengembangan aplikasi portofolio mobile berdasarkan proyek website portofolio yang telah dibuat sebelumnya.
* Menyesuaikan informasi profil dengan identitas pribadi.
* Menentukan warna tema aplikasi agar konsisten dengan website portofolio.
* Memahami dan menyesuaikan model data `ItemHomepage`.
* Menerapkan atribut warna pada daftar `items` dan komponen `ItemCard`.
* Menjalankan perintah pengembangan dan pemeriksaan proyek pada lingkungan lokal.
* Memeriksa hasil implementasi dan melakukan perbaikan ketika ditemukan kesalahan.
* Melakukan pengelolaan branch dan commit untuk bagian wajib tugas.
* Mempelajari kembali konsep yang digunakan agar dapat menjelaskan implementasi aplikasi secara mandiri.

#### Keterbatasan dan Evaluasi Penggunaan AI

Selama proses pengerjaan, saya menemukan bahwa hasil yang diberikan AI tidak selalu dapat langsung diterapkan.

Beberapa kendala yang ditemukan antara lain:

* Perbedaan lingkungan pengembangan menyebabkan dependensi yang tersedia pada lingkungan AI tidak selalu sama dengan lingkungan lokal.
* Beberapa kode yang disarankan masih memerlukan penyesuaian setelah diperiksa menggunakan `flutter analyze`.
* Hasil pengujian otomatis belum tentu menggambarkan keseluruhan kualitas tampilan aplikasi.
* Pemahaman terhadap kode tetap diperlukan karena AI tidak selalu memberikan implementasi yang sesuai dengan kebutuhan proyek.

Oleh karena itu, setiap saran dan implementasi yang diperoleh dari AI tetap perlu diperiksa dan disesuaikan sebelum digunakan dalam proyek.

### Tutorial 09 dan Tugas 8

#### Tools

**Claude (model Opus 5.5) melalui Claude Code** di aplikasi desktop, 18 November 2026.

#### Strategi Penggunaan AI

Untuk Tutorial 09 dan Tugas 8, saya mendelegasikan pengerjaan kepada AI. Saya
memberikan berkas soal (`tutorial-9.pdf` dan `tugas-8.pdf`) lalu meminta AI
mengerjakan seluruhnya, dengan syarat commit tidak memuat atribusi AI, dan meminta
penjelasan setelahnya. Prompt utama yang saya berikan (diringkas):

1. "bantu aku buat kerjain tutorial 9 dong" (beserta `tutorial-9.pdf`)
2. "tolong kamu aja dong yang kerjain semuanya, habis itu jelasin ya pas aku minta"
3. "ini kerjain jg dong" (beserta `tugas-8.pdf`)

AI membaca soal, memeriksa kode proyek dan model `Experience` di repositori website
Django, lalu menulis kode, test, dan README. Setiap langkah diperiksa dengan
`flutter analyze` dan `flutter test` sebelum di-commit.

#### Bagian yang Dibantu AI

* **Kode:** seluruh kode Tutorial 09 (drawer, form proyek, navigasi tombol,
  refactoring folder) dan Tugas 8 (`ExperienceFormPage`, kartu aksi, opsi drawer,
  `ItemHomepage.page`).
* **Pemilihan field:** AI memilih bagian Experience dan menyamakan field serta aturan
  validasinya dengan `main/models.py` dan `main/forms.py` di website saya.
* **Test:** 9 test baru untuk drawer, kedua form, validasi, dan layar selebar ponsel.
* **Dokumentasi:** progres mingguan, jawaban pertanyaan reflektif Tugas 8, dan bagian
  AI disclosure ini.
* **Git:** branch `feat/individual-assignment-8` dan commit bertahap dengan format
  conventional commits.

#### Bagian yang Saya Kerjakan dan Bertanggung Jawab

* Menyediakan berkas soal dan menentukan apa yang perlu dikerjakan.
* Menentukan aturan bahwa commit tidak memuat atribusi AI.
* Memeriksa hasil akhir dan mengumpulkan tautan commit ke SCELE.
* Mempelajari penjelasan kode dari AI agar dapat menjelaskan implementasinya secara
  mandiri, terutama untuk persiapan UAS.

#### Keterbatasan dan Evaluasi Penggunaan AI

* **Contoh kode tutorial tidak selalu benar.** Pada form proyek, setelah OK ditekan,
  dropdown kembali ke kategori awal tetapi variabel `_category` masih menyimpan
  kategori lama, sehingga dialog berikutnya bisa salah. AI menemukan dan memperbaikinya.
* **Test menemukan masalah yang tidak terlihat dari kode.** Header drawer meluber
  jika ukuran huruf diperbesar, dan halaman form yang memakai drawer tidak punya panah
  Back di AppBar (kembali harus lewat tombol Back perangkat atau opsi Home). Keduanya
  baru ketahuan saat test dijalankan.
* **Pemeriksaan visual oleh AI terbatas.** Saat AI mencoba aplikasi di panel browser,
  posisi klik tidak akurat, sehingga perilaku navigasi dan form dipastikan lewat
  widget test, bukan lewat klik manual. Saya tetap perlu mencoba aplikasi sendiri di
  Chrome.
* **Pemahaman tetap tanggung jawab saya.** Karena kode ditulis AI, nilai pembelajarannya
  bergantung pada apakah saya mempelajari penjelasannya. Hal ini saya catat sebagai
  tindak lanjut untuk persiapan UAS.
