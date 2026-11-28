# My Portofolio Mobile

[![CI](https://github.com/raa-arianti/myportofolio_mobile/actions/workflows/main.yaml/badge.svg)](https://github.com/raa-arianti/myportofolio_mobile/actions/workflows/main.yaml)

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
  (backend DRF yang dipakai aplikasi ini; endpoint token login mulai commit
  [`127290b`](https://github.com/raa-arianti/myportofolio/commit/127290b27efd79659db419a983145ebabf6360c7))
- **Website (PWS):** https://ira-arianti-myportofolio.pws.cs.ui.ac.id

---

## Tentang Proyek

Sejak Tutorial 10 dan Tugas 9, aplikasi sudah **terhubung ke API Django REST
Framework**: data Project dan Experience diambil dari server, dan menambah data
memakai login token. Ringkasan per tugas ada di [Progres Mingguan](#progres-mingguan).

| Bagian | Baca (publik) | Tulis (wajib login token) |
|---|---|---|
| Project | `GET /api/v1/projects/` → daftar + detail | `POST /api/v1/projects/` dari form Tambah Proyek |
| Experience | `GET /api/v1/experience/` → daftar + detail | `POST /api/v1/experience/` dari form Tambah Experience, `DELETE /api/v1/experience/<id>/` dari halaman detail |

Login memakai `POST /api/v1/auth/token/` dan logout memakai `POST /api/v1/auth/logout/`
(token dicabut di server).

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

Sampai Tugas 8 data form belum disimpan ke database. Mulai Tutorial 10 dan Tugas 9
data dikirim ke API Django (lihat tabel di atas).

## Teknologi

| | |
|---|---|
| Framework | Flutter 3.47.5 (channel stable) |
| Bahasa | Dart (SDK `^3.13.4`) |
| Desain | Material 3, lewat paket `material_ui` |
| Aturan lint | `flutter_lints` |
| HTTP | `http` (+ `MockClient` dari `package:http/testing.dart` untuk test) |
| State & DI | `provider` (`MultiProvider`, `ChangeNotifier`) |
| JSON | `json_annotation` + `json_serializable` (code generation dengan `build_runner`) |
| CI/CD | GitHub Actions: `very_good_workflows` + build APK release |

## Struktur Proyek

```
lib/
├── main.dart                   # runApp, MultiProvider (ApiClient + AuthState), MaterialApp, tema
├── config.dart                 # apiBaseUrl dari --dart-define=API_BASE_URL
├── models/
│   ├── item_homepage.dart      # ItemHomepage: tombol menu (halaman tujuan, wajib login, logout)
│   ├── project.dart            # Project (@JsonSerializable), Tutorial 10
│   └── experience.dart         # Experience (@JsonSerializable), Tugas 9
├── services/
│   ├── api_client.dart         # ApiClient + ApiException: semua pemanggilan HTTP
│   └── auth_state.dart         # AuthState (ChangeNotifier): token login di memori
├── screens/
│   ├── menu.dart               # MyHomePage, halaman utama
│   ├── login_screen.dart       # LoginScreen
│   ├── project_list_screen.dart, project_detail_screen.dart, project_form.dart
│   └── experience_list_screen.dart, experience_detail_screen.dart, experience_form.dart
└── widgets/
    ├── auth_guard.dart         # ensureLoggedIn(context): buka LoginScreen kalau belum login
    ├── info_card.dart          # InfoCard, kartu profil
    ├── left_drawer.dart        # LeftDrawer, menu navigasi samping (+ Login/Logout)
    └── project_card.dart       # ItemCard, tombol menu, SnackBar, dan navigasinya
test/
├── fake_api.dart               # ApiClient palsu (MockClient) + pembungkus provider
├── api_client_test.dart        # unit test ApiClient
├── widget_test.dart            # halaman utama, login, drawer, daftar dan form proyek
├── experience_list_test.dart   # daftar, detail, dan hapus Experience
└── experience_form_test.dart   # form Experience: validasi, POST, 401, 403
.github/workflows/main.yaml     # CI (very_good_workflows) + build_apk
```

Folder `android/`, `ios/`, `web/`, `windows/`, `linux/`, dan `macos/` dibuat oleh
`flutter create` dan berisi pembungkus untuk tiap platform.

## Menjalankan Secara Lokal

Prasyarat: Flutter SDK sudah terpasang dan `flutter` ada di PATH, serta backend Django
dari [repositori web](https://github.com/raa-arianti/myportofolio) bisa dijalankan.

### 1. Jalankan backend Django

```bash
git clone https://github.com/raa-arianti/myportofolio.git
cd myportofolio
python -m venv env && source env/bin/activate   # Windows: env\Scripts\activate
pip install -r requirements.txt
python manage.py migrate                         # termasuk tabel authtoken_token
python manage.py createsuperuser                 # akun untuk login dari aplikasi
python manage.py runserver
```

Hanya **superuser** (pemilik portofolio) yang boleh menambah atau menghapus data
lewat API. Akun biasa tetap bisa login, tetapi POST/DELETE-nya ditolak dengan 403.

### 2. Jalankan aplikasi Flutter

```bash
git clone https://github.com/raa-arianti/myportofolio_mobile.git
cd myportofolio_mobile
flutter pub get

# Membuat berkas *.g.dart (tidak ikut di-commit). Ulangi setiap kali model diubah.
dart run build_runner build --delete-conflicting-outputs
```

Alamat backend diatur lewat `--dart-define=API_BASE_URL=...` (tanpa `/` di akhir).
Bawaannya `http://10.0.2.2:8000`, yaitu laptop jika dilihat dari emulator Android.

| Target | Perintah |
|---|---|
| Emulator Android + Django lokal | `flutter run` |
| Chrome + Django lokal | `flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000` |
| HP Android (USB) + Django lokal | `adb reverse tcp:8000 tcp:8000` lalu `flutter run --dart-define=API_BASE_URL=http://localhost:8000` |
| Backend yang sudah di-deploy | `flutter run --dart-define=API_BASE_URL=https://<domain-backend>` |

### 3. Pemeriksaan kode

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

Hasil terakhir (Tugas 9): format tidak mengubah apa pun, `flutter analyze` menampilkan
`No issues found!`, dan 33 test lulus. Test memakai `MockClient`, jadi tidak perlu
server Django.

### 4. CI/CD

Setiap push ke `main` dan setiap pull request menjalankan
[`.github/workflows/main.yaml`](.github/workflows/main.yaml):

- **`build`** (`very_good_workflows`): `build_runner`, cek format, `flutter analyze`, dan
  `flutter test` dengan coverage.
- **`build_apk`**: berjalan hanya jika `build` lulus, membangun APK release, lalu
  mengunggahnya sebagai artefak **`app-release-apk`** (unduh dari halaman run di tab
  Actions).

APK memakai variabel repositori `API_BASE_URL` (Settings → Secrets and variables →
Actions → Variables) jika diisi. Jika kosong, APK memakai alamat bawaan `10.0.2.2`.

### Menguji penanganan 401

Login di aplikasi, hapus token akun itu lewat Django Admin (**Auth Token → Tokens**)
atau `python manage.py shell`, lalu kirim form Experience. Aplikasi menghapus sesinya,
menampilkan "Sesi berakhir, silakan login ulang.", dan membuka layar login.

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

### Tutorial 10, Flutter Backend Integration, Authentication, and CI/CD

- **Backend Django:** mengaktifkan `TokenAuthentication` (sebelum `SessionAuthentication`)
  dan `django-cors-headers`, menambah endpoint `auth/token/` dan `auth/logout/`, serta
  menambahkan `10.0.2.2` ke `ALLOWED_HOSTS`.
- Membuat model `Project` dengan `@JsonSerializable` dan field yang mengikuti
  `ProjectSerializer` milik backend saya (`title`, `description`, `thumbnail`, dan field
  star), bukan field mock form Tutorial 09.
- Membuat `ApiClient`, `AuthState`, `LoginScreen`, `ensureLoggedIn`, daftar dan detail
  proyek, serta menghubungkan form proyek ke `POST /api/v1/projects/`.
- Menambah workflow GitHub Actions dengan `very_good_workflows` dan job `build_apk`.

### Tugas 9, Integrasi Experience

- **Model:** `Experience` di `lib/models/experience.dart`, sesuai `ExperienceSerializer`.
  Field yang diisi server (`id`, `category_label`, `started_at`, `is_ongoing`, dan field
  star) memakai `@JsonKey(includeToJson: false)`, dan field opsional punya nilai default.
- **ApiClient:** `getExperiences()` (publik), `createExperience()` dan
  `deleteExperience()` (dengan `Authorization: Token <key>`).
- **Daftar Experience** (`ExperienceListScreen`): `FutureBuilder` dengan `Future` dari
  `initState()`, `RefreshIndicator`, serta tampilan loading, error dengan tombol
  **Retry**, dan kosong. Dibuka dari kartu **Lihat Experience** dan opsi
  **View Experience** di drawer.
- **Detail Experience** (`ExperienceDetailScreen`): semua field, termasuk gambar (jika ada),
  tanggal mulai dan selesai, status masih berjalan, serta jumlah dan nama pemberi star.
- **Form Experience:** kartu **Tambah Experience**, opsi drawer **Add Experience**, dan
  tombol **+** di daftar meminta login dulu (`ensureLoggedIn`). Tombol Simpan juga
  memeriksa login lagi, lalu mengirim `POST /api/v1/experience/`. Error 401 menghapus
  sesi dan membuka layar login; error lain (403, 400) tampil sebagai SnackBar. Setelah
  berhasil, dialog menawarkan **Tambah lagi** atau **Lihat daftar** (daftar memuat ulang
  sehingga entri baru langsung muncul).
- **Fitur tambahan di luar checklist:**
  - hapus Experience (`DELETE`, wajib login, dengan dialog konfirmasi), daftar dimuat
    ulang setelah hapus;
  - 18 test baru (dari 15 menjadi 33): unit test `ApiClient` dengan `MockClient`, serta
    widget test untuk daftar, detail, hapus, form, 401, dan 403;
  - versi Flutter dan JDK di CI dikunci agar sama dengan lingkungan lokal.
- **Perbaikan bug** yang ditemukan oleh test: menekan Retry saat server masih error
  sebelumnya melempar error yang tidak tertangkap (juga di daftar proyek), dan tanggal di
  detail sebelumnya tampil tanpa tahun.

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

### Assignment 9

1. **Mengapa `@JsonSerializable(fieldRename: FieldRename.snake)` dan
   `@JsonKey(includeToJson: false)`, bukan `Map<String, dynamic>` mentah dari widget?**

   Dengan model, bentuk data ditulis **sekali** di `lib/models/experience.dart`, dan
   kode konversinya (`fromJson`/`toJson`) dibuat oleh `build_runner`, bukan diketik
   tangan di setiap widget. Hasilnya:

   - `FieldRename.snake` memetakan nama Dart (`endedAt`, `categoryLabel`) ke nama
     JSON DRF (`ended_at`, `category_label`) secara konsisten;
   - kompiler memeriksa tipe: `endedAt` adalah `DateTime?`, bukan `dynamic`, jadi salah
     ketik nama field atau salah tipe ketahuan saat kompilasi, bukan saat aplikasi jalan;
   - `includeToJson: false` memastikan field yang diisi server (`id`, `started_at`,
     `is_ongoing`, `star_count`, ...) tidak pernah terkirim saat POST.

   **Bug yang dicegah di model Experience:** kalau widget membuat `Map` sendiri, mudah
   sekali menulis `{'endedAt': ...}` (gaya Dart). DRF **diam-diam mengabaikan** kunci
   yang tidak dikenal, jadi request tetap 201 tetapi `ended_at` tersimpan `null`, dan
   pengalaman yang sudah selesai tampil sebagai "Masih berjalan". Tidak ada error yang
   memberi tahu. Dengan model, kuncinya selalu `ended_at`, dan
   `test/api_client_test.dart` memeriksa body POST persis sama dengan yang diharapkan
   (termasuk bahwa `id` dan `star_count` tidak ikut).

2. **Mengapa `Future` dibuat di `initState()`, dan mengapa `ApiClient` melempar
   `ApiException` daripada mengembalikan `null`?**

   `build()` bisa dipanggil berkali-kali: saat `setState`, saat drawer dibuka, saat
   tema atau ukuran layar berubah, saat keyboard muncul. Jika `getExperiences()`
   dipanggil di dalam `build()`, setiap rebuild membuat `Future` **baru**, yang berarti
   request HTTP baru, dan `FutureBuilder` kembali ke status *waiting* (indikator loading
   berkedip). Request bisa berulang tanpa henti dan membebani server. Di `initState()`,
   `Future` dibuat sekali per halaman. `FutureBuilder` hanya mendengarkan `Future` yang
   sama, dan request baru hanya dibuat secara sengaja lewat `_reload()` (Retry atau tarik
   ke bawah) dengan `setState`.

   `ApiException` membawa **alasan** kegagalan (`statusCode` dan isi respons), dan alasan
   itu menentukan reaksi aplikasi: 401 berarti hapus sesi dan login ulang, 403 berarti
   "hanya pemilik", 400 berarti data ditolak, 500 berarti error server dengan tombol
   Retry. `null` tidak bisa membedakan semua itu. Selain itu, `null` mudah lupa
   diperiksa, sehingga error muncul jauh dari sumbernya, misalnya daftar tampil
   "Belum ada experience" padahal server sedang mati. Exception justru **memaksa**
   kegagalan ditangani: `FutureBuilder` otomatis masuk ke `snapshot.hasError`, dan
   `try/on ApiException` di form memilih pesan sesuai status. Tipe kembalian juga tetap
   bersih (`Future<List<Experience>>`, bukan `Future<List<Experience>?>`).

3. **`SessionAuthentication` vs `TokenAuthentication`; mengapa aplikasi mobile memakai
   token sementara session tetap aktif?**

   | | `SessionAuthentication` (Tutorial 04/07) | `TokenAuthentication` (Tutorial 10) |
   |---|---|---|
   | Bukti login | Cookie `sessionid`, data session disimpan di server | Header `Authorization: Token <key>`, token disimpan di tabel `authtoken_token` |
   | Dikirim oleh | Browser, otomatis di setiap request | Klien, ditambahkan sendiri ke header |
   | CSRF | Wajib (cookie terkirim otomatis, jadi rawan CSRF) | Tidak perlu (header tidak terkirim otomatis oleh situs lain) |
   | Tanpa login | 403 | 401 (dengan header `WWW-Authenticate: Token`) |
   | Logout | Session dihapus | Token dihapus (`POST /api/v1/auth/logout/`) |

   Aplikasi Flutter bukan browser: tidak punya pengelolaan cookie otomatis atau alur
   CSRF dari halaman HTML. Token cukup disimpan di `AuthState` dan ditempel ke header
   oleh `ApiClient`, sama di Android, iOS, maupun web. Session tetap aktif karena website
   Django (halaman HTML dan JavaScript fetch dari Tutorial 07) masih login lewat form dan
   cookie. Keduanya didaftarkan di `DEFAULT_AUTHENTICATION_CLASSES` dan DRF mencoba
   berurutan. Token sengaja diletakkan **pertama**, supaya request tanpa kredensial
   mendapat **401** (bukan 403), sehingga aplikasi bisa membedakan "belum login atau
   token kedaluwarsa" (login ulang) dari "sudah login tetapi tidak berhak" (403).

4. **Peran job `build` dan `build_apk`, serta mengapa `*.g.dart` di-`.gitignore`.**

   - **`build`** memakai workflow `flutter_package.yml` dari `very_good_workflows`.
     Di run GitHub Actions, langkah yang dijalankannya terlihat berurutan: checkout,
     setup Flutter (versi dikunci 3.47.5), `flutter pub get`, menjalankan `setup` kita
     (`dart run build_runner build`), **cek format** (`dart format --set-exit-if-changed`),
     **analisis statis** (`flutter analyze`), lalu **test dengan coverage**
     (`flutter test --coverage`) dan pemeriksaan `min_coverage`. Coverage `*.g.dart`
     dikecualikan, dan `min_coverage: 0` dipakai karena pengujian belum dibahas di kelas.
     Langkah seperti Bloc Lint dilewati karena tidak dipakai.
   - **`build_apk`** punya `needs: build`, jadi hanya berjalan kalau `build` hijau. Job
     ini menyiapkan JDK 17 dan Flutter, menjalankan `build_runner`, membangun
     `flutter build apk --release` (dengan `--dart-define=API_BASE_URL` jika variabel
     repositori diisi), lalu mengunggah `app-release.apk` sebagai artefak
     `app-release-apk`. `build` adalah **CI** (memastikan kode layak digabung), sedangkan
     `build_apk` adalah **CD** sederhana (menghasilkan aplikasi yang siap dipasang).

   `*.g.dart` di-`.gitignore` karena berkas itu **turunan** dari `models/*.dart`:
   sumber kebenarannya adalah anotasi di model. Kalau ikut di-commit, berkas itu bisa
   basi, misalnya saya menambah field di `experience.dart` tetapi lupa menjalankan ulang
   `build_runner`, sehingga repositori berisi model dan konversi JSON yang tidak cocok.
   Berkas hasil generasi juga membuat diff besar dan konflik merge yang tidak bermakna.
   CI tetap bisa menganalisis dan membangun aplikasi karena kedua job menjalankan
   `dart run build_runner build --delete-conflicting-outputs` sendiri sebelum analyze,
   test, dan build. Dengan begitu kode hasil generasi di CI selalu dibuat ulang dari
   model terbaru. Di `analysis_options.yaml` berkas ini juga dikecualikan, karena kode
   hasil generator tidak perlu diperiksa linter.

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

Dalam pengerjaan Tutorial 09 dan Tugas 8, saya menggunakan AI sebagai asisten untuk membantu proses pengembangan dan pemecahan masalah teknis. Proses pengerjaan terutama dilakukan secara mandiri, mulai dari memahami instruksi soal, menentukan pendekatan implementasi, menulis dan mengintegrasikan kode, hingga memeriksa hasil pengerjaan.

Saya menggunakan Claude ketika mengalami kesulitan memahami alur implementasi atau menemukan solusi untuk permasalahan tertentu. Dalam beberapa situasi ketika belum mengetahui bagaimana memulai implementasi, saya meminta AI memberikan pseudocode sebagai gambaran alur penyelesaian sebelum mengimplementasikannya sendiri.

Interaksi dengan AI dilakukan melalui beberapa bentuk, antara lain:
1. Meminta penjelasan konsep, fungsi, dan alur kerja kode tertentu.
2. Meminta pseudocode ketika mengalami kesulitan menentukan langkah implementasi.
3. Berkonsultasi mengenai error dan debugging.
4. Meminta review terhadap kode serta saran perbaikan implementasi.
5. Meminta bantuan untuk memahami hasil testing dan kemungkinan edge cases.

#### Bagian yang Dibantu AI

* **Konsultasi implementasi:** Memberikan gambaran alur penyelesaian melalui pseudocode ketika saya mengalami kesulitan memulai implementasi.
* **Debugging:** Membantu mengidentifikasi penyebab error dan memberikan alternatif solusi terhadap masalah yang ditemukan.
* **Code review:** Memberikan masukan mengenai struktur kode, konsistensi implementasi, dan kemungkinan perbaikan.
* **Testing:** Membantu mengidentifikasi potensi edge cases serta memahami hasil pengujian menggunakan `flutter analyze` dan `flutter test`.
* **Dokumentasi:** Membantu penyusunan dan pemeriksaan dokumentasi, termasuk progres mingguan, jawaban pertanyaan reflektif, dan AI disclosure.

#### Bagian yang Saya Kerjakan dan Bertanggung Jawab

* Membaca dan memahami instruksi Tutorial 09 dan Tugas 8.
* Menentukan pendekatan dan alur implementasi berdasarkan kebutuhan setiap soal.
* Menulis, menyesuaikan, dan mengintegrasikan kode ke dalam proyek.
* Menentukan kapan membutuhkan bantuan AI, terutama ketika mengalami kesulitan memahami konsep atau menemukan solusi implementasi.
* Memeriksa dan mengevaluasi hasil implementasi sebelum dikumpulkan.
* Memahami fungsi dan alur kerja kode agar dapat menjelaskan implementasinya secara mandiri, terutama untuk persiapan UAS.

#### Keterbatasan dan Evaluasi Penggunaan AI

* **Saran AI tetap perlu dievaluasi.** Tidak semua saran implementasi yang diberikan AI dapat langsung diterapkan. Saya perlu menyesuaikannya dengan struktur proyek, kebutuhan soal, dan kode yang sudah ada.
* **Pseudocode tidak selalu langsung menghasilkan implementasi yang benar.** Gambaran alur dari AI membantu saya memahami langkah penyelesaian, tetapi implementasi tetap memerlukan penyesuaian dan pemeriksaan lebih lanjut.
* **Testing tetap diperlukan.** Pemeriksaan menggunakan `flutter analyze` dan `flutter test` membantu menemukan potensi masalah yang mungkin tidak terlihat hanya dengan membaca kode.
* **Pemeriksaan visual memiliki keterbatasan.** Pengujian melalui panel browser AI tidak selalu akurat, sehingga saya tetap perlu melakukan pemeriksaan langsung melalui Chrome.
* **Pemahaman tetap menjadi tanggung jawab saya.** Bantuan AI tidak menggantikan proses belajar. Saya perlu memahami alasan di balik setiap implementasi, termasuk fungsi, alur navigasi, validasi form, dan struktur kode agar dapat mempertanggungjawabkan hasil pengerjaan secara mandiri.

### Tutorial 10 dan Tugas 9

#### Tools

**Claude (model Opus 5.5) melalui Claude Code** di aplikasi desktop, 25–26 November 2026.

#### Strategi Penggunaan AI

Dalam pengerjaan Tutorial 10 dan Tugas 9, saya menggunakan AI jauh lebih intensif dibandingkan tugas-tugas sebelumnya. Hal ini terutama karena terdapat beberapa konsep dan kebutuhan implementasi baru yang belum sepenuhnya saya pahami, sehingga saya lebih sering meminta bantuan Claude dalam menuliskan kode dan menentukan pendekatan implementasi.

Proses pengerjaan tetap saya lakukan secara aktif melalui kombinasi implementasi mandiri dan diskusi dengan Claude. Untuk bagian yang sudah saya pahami, saya tetap mengerjakan dan menyesuaikan kode sendiri. Sementara itu, ketika menghadapi implementasi yang belum saya kuasai, saya meminta Claude memberikan contoh kode, membantu menyusun implementasi, menjelaskan alur kerja, serta memberikan alternatif penyelesaian.

Interaksi dengan AI dilakukan secara iteratif. Saya tidak hanya menerima hasil implementasi, tetapi juga menjalankan aplikasi, memeriksa hasil pengujian, mengidentifikasi masalah, dan mendiskusikan perbaikannya bersama Claude. Dengan demikian, AI berperan sebagai alat bantu implementasi dan konsultasi teknis selama proses pengembangan.

Penggunaan AI mencakup beberapa aktivitas:
1. Meminta penjelasan konsep dan alur implementasi fitur baru.
2. Meminta bantuan penulisan kode ketika belum memahami cara mengimplementasikan kebutuhan tertentu.
3. Mendiskusikan struktur kode, integrasi antara frontend Flutter dan backend Django, serta penanganan autentikasi.
4. Meminta bantuan debugging dan menganalisis hasil pengujian.
5. Mendiskusikan alternatif perbaikan berdasarkan masalah yang ditemukan saat pengujian manual.

#### Bagian yang Dibantu AI

* **Backend Django (Tutorial 10):** Membantu implementasi konfigurasi `TokenAuthentication`, CORS, endpoint token login dan logout, serta penyesuaian dan penambahan test API.
* **Flutter:** Membantu penulisan dan pengembangan beberapa bagian implementasi, termasuk model `Project` dan `Experience`, `ApiClient`, `AuthState`, `LoginScreen`, `ensureLoggedIn`, halaman daftar dan detail, integrasi form Project dan Experience dengan metode POST, fitur hapus Experience, serta navigasi menu dan drawer.
* **Test:** Membantu implementasi `fake_api.dart` menggunakan `MockClient`, unit test `ApiClient`, dan widget test, serta mendiskusikan hasil pengujian dan perbaikan yang diperlukan.
* **CI/CD:** Membantu konfigurasi workflow GitHub Actions dan menganalisis kemungkinan penyebab kegagalan job `build_apk` pada run pertama.
* **Dokumentasi:** Membantu menyusun dan memeriksa draf README, termasuk jawaban pertanyaan reflektif dan dokumentasi progres pengerjaan.

#### Bagian yang Saya Kerjakan dan Bertanggung Jawab

* Membaca dan memahami instruksi Tutorial 10 dan Tugas 9 serta menentukan pengembangan yang diperlukan pada repositori Django dan Flutter yang sudah ada.
* Menentukan kebutuhan fitur dan menyesuaikan implementasi dengan struktur serta model data pada proyek sebelumnya.
* Tetap mengerjakan bagian implementasi yang sudah saya pahami secara mandiri dan menentukan bagian yang membutuhkan bantuan AI.
* Berdiskusi dengan Claude mengenai pendekatan implementasi, memahami kode yang dihasilkan, dan menentukan penyesuaian yang diperlukan.
* Menjalankan pemeriksaan kode dan pengujian aplikasi, termasuk `flutter analyze`, `flutter test`, serta pengujian manual menggunakan server Django lokal dan Flutter di Chrome.
* Mengidentifikasi masalah yang tidak ditemukan oleh pengujian otomatis dan mendiskusikan perbaikannya bersama Claude.
* Memeriksa kembali hasil implementasi setelah perubahan dilakukan untuk memastikan fitur berjalan sesuai kebutuhan.
* Bertanggung jawab atas hasil akhir yang dikumpulkan, termasuk mempelajari kembali alur autentikasi (`ensureLoggedIn` → `AuthState.login` → header `Authorization: Token`), penggunaan `FutureBuilder` dengan `Future` dari `initState`, dan penanganan `ApiException`.

#### Keterbatasan dan Evaluasi Penggunaan AI

* **Penggunaan AI yang lebih intensif tetap membutuhkan pemeriksaan.** Karena terdapat beberapa implementasi baru yang belum saya kuasai, saya lebih banyak mengandalkan bantuan Claude untuk penulisan kode. Namun, kode yang dihasilkan tetap perlu dipahami, disesuaikan, dan diuji sebelum digunakan.
* **Instruksi tutorial tidak selalu cocok dengan proyek saya.** Contoh di PDF menggunakan field `tech_stack` dan `project_url`, sedangkan serializer pada backend saya menggunakan `thumbnail`. Implementasi perlu disesuaikan dengan struktur backend yang sebenarnya.
* **Test otomatis tidak selalu menangkap seluruh masalah.** Beberapa bug baru ditemukan setelah pengujian, seperti error yang tidak tertangkap ketika menekan Retry dan format tanggal yang tidak menampilkan tahun. Hal ini menunjukkan bahwa hasil implementasi maupun test yang dibantu AI tetap perlu diperiksa.
* **Pengujian manual menemukan masalah yang tidak terlihat pada test otomatis.** Contohnya, pesan login yang salah awalnya menampilkan "Login failed (status 400)". Setelah mencoba aplikasi dengan backend Django sungguhan, saya menilai pesan tersebut kurang informatif bagi pengguna. Saya kemudian mendiskusikan dan melakukan perbaikan menjadi "Username atau password salah." di `login_screen.dart`, sekaligus menyesuaikan test terkait.
* **Lingkungan pengembangan AI memiliki keterbatasan.** AI tidak memiliki Android SDK, sehingga build APK tidak dapat dicoba secara lokal melalui emulator. Selain itu, penyebab kegagalan awal job `build_apk` tidak dapat diperiksa langsung karena log GitHub Actions memerlukan autentikasi. Perbaikan konfigurasi kemudian diuji melalui run berikutnya yang berhasil menghasilkan kedua job berstatus hijau dan artefak `app-release-apk`.
* **Pengujian otomatis tidak menggantikan pengujian dengan backend sebenarnya.** Test menggunakan `MockClient`, sehingga tidak sepenuhnya merepresentasikan interaksi aplikasi dengan server Django. Karena itu, saya tetap melakukan pengujian manual menggunakan server lokal untuk memeriksa alur login, pengiriman data, penghapusan data, dan penanganan sesi berakhir.
* **Pengujian platform masih terbatas.** Pengujian manual baru dilakukan melalui Chrome. Aplikasi belum diuji menggunakan emulator Android atau perangkat Android fisik karena laptop belum memiliki Android SDK.
* **Pemahaman tetap menjadi tanggung jawab saya.** Penggunaan AI yang lebih intensif tidak menghilangkan kebutuhan untuk memahami implementasi. Saya perlu mempelajari kembali kode, konsep, dan alur kerja aplikasi secara menyeluruh agar dapat menjelaskan serta mempertanggungjawabkan hasil pengerjaan secara mandiri, terutama untuk persiapan UAS.