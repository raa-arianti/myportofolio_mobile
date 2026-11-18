import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// Halaman form untuk menambah pengalaman (Experience).
///
/// Field dan aturannya mengikuti model `Experience` dan `ExperienceForm` di
/// website portofolio (Django):
/// - `title`: wajib, maksimal 255 karakter;
/// - `description`: wajib;
/// - `category`: salah satu dari [categories], bawaan Full-Time;
/// - `thumbnail`: opsional, harus URL http(s) yang valid;
/// - `ended_at`: opsional; kosong berarti pengalaman masih berjalan.
///
/// Data belum dikirim ke Django; setelah Simpan, ringkasannya tampil di dialog.
class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  /// Pilihan kategori, sama dengan `Experience.EXPERIENCE_CHOICES` di Django:
  /// nilai yang disimpan → label yang ditampilkan.
  static const Map<String, String> categories = {
    'internship': 'Internship',
    'research': 'Research',
    'volunteer': 'Volunteer',
    'part-time': 'Part-Time',
    'full-time': 'Full-Time',
    'freelance': 'Freelance',
  };

  /// Batas panjang judul, sama dengan `max_length=255` di model Django.
  static const int titleMaxLength = 255;

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  // Kunci untuk mengakses state Form: validate() dan reset().
  final _formKey = GlobalKey<FormState>();

  // Isian teks dibaca dari controller saat Simpan ditekan, jadi tidak perlu
  // setState di setiap ketikan.
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _thumbnail = TextEditingController();
  // Kolom tanggal hanya menampilkan tanggal terpilih; isinya diatur kode.
  final _endDateText = TextEditingController();

  String _category = 'full-time'; // default, sama dengan model Django
  DateTime? _endDate; // null = masih berjalan

  @override
  void dispose() {
    // Controller memegang sumber daya, jadi dilepas saat halaman ditutup.
    _title.dispose();
    _description.dispose();
    _thumbnail.dispose();
    _endDateText.dispose();
    super.dispose();
  }

  // ---------- Validasi (dibuat terpisah supaya mudah dibaca dan diuji) ----------

  /// Menolak isian kosong dan isian yang hanya berisi spasi.
  static String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label tidak boleh kosong!';
    }
    return null;
  }

  static String? _validateTitle(String? value) {
    return _required(value, 'Judul') ??
        (value!.trim().length > ExperienceFormPage.titleMaxLength
            ? 'Judul maksimal ${ExperienceFormPage.titleMaxLength} karakter.'
            : null);
  }

  /// URL gambar boleh kosong. Kalau diisi, harus diawali http:// atau https://
  /// dan punya nama domain, seperti yang diterima `URLField` di Django.
  static String? _validateThumbnail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final uri = Uri.tryParse(text);
    final valid =
        uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.contains('.');
    return valid
        ? null
        : 'Masukkan URL yang valid, misalnya https://contoh.com/foto.jpg';
  }

  /// Tanggal selesai tidak boleh di masa depan: pengalaman yang belum selesai
  /// dibiarkan kosong (masih berjalan), sesuai `is_ongoing` di model Django.
  String? _validateEndDate(String? _) {
    final end = _endDate;
    if (end != null && end.isAfter(DateUtils.dateOnly(DateTime.now()))) {
      return 'Tanggal selesai tidak boleh di masa depan. Kosongkan jika masih berjalan.';
    }
    return null;
  }

  // ---------- Aksi ----------

  Future<void> _pickEndDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? today,
      firstDate: DateTime(1990),
      lastDate: today, // tanggal di masa depan tidak bisa dipilih
      helpText: 'Pilih tanggal selesai',
    );
    if (picked != null) _setEndDate(picked);
  }

  void _setEndDate(DateTime? date) {
    setState(() {
      _endDate = date;
      _endDateText.text = date == null
          ? ''
          : MaterialLocalizations.of(context).formatMediumDate(date);
    });
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _title.clear();
    _description.clear();
    _thumbnail.clear();
    _setEndDate(null);
    setState(() => _category = 'full-time');
  }

  void _save() {
    // validate() menjalankan semua validator; pesan error muncul di kolomnya.
    if (!_formKey.currentState!.validate()) return;

    final thumbnail = _thumbnail.text.trim();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Experience berhasil disimpan!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _SummaryRow('Judul', _title.text.trim()),
                _SummaryRow('Deskripsi', _description.text.trim()),
                _SummaryRow(
                  'Kategori',
                  ExperienceFormPage.categories[_category]!,
                ),
                _SummaryRow(
                  'URL gambar',
                  thumbnail.isEmpty ? '(tidak ada)' : thumbnail,
                ),
                _SummaryRow(
                  'Tanggal selesai',
                  _endDate == null ? 'Masih berjalan' : _endDateText.text,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context); // tutup dialog, kembali ke form
                _resetForm();
              },
            ),
          ],
        );
      },
    );
  }

  // ---------- Tampilan ----------

  InputDecoration _decoration(String label, {String? hint, String? helper}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      helperText: helper,
      helperMaxLines: 2,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      // AppBar memakai warna utama tema, sama dengan halaman utama dan form proyek.
      appBar: AppBar(
        title: const Text('Add Experience Form'),
        centerTitle: true,
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        // Kolom yang sudah disentuh langsung divalidasi ulang setiap kali diubah,
        // jadi pesan error hilang begitu isiannya diperbaiki.
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SafeArea(
          // Bisa digulir, jadi semua kolom dan tombol Simpan tetap terjangkau di
          // layar sempit atau saat papan ketik menutupi separuh layar.
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              // Di layar lebar form tidak melebar sampai ke tepi.
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // === Judul ===
                    TextFormField(
                      controller: _title,
                      maxLength: ExperienceFormPage.titleMaxLength,
                      textInputAction: TextInputAction.next,
                      decoration: _decoration(
                        'Judul / peran',
                        hint: 'Staff of Community Service Department',
                      ),
                      validator: _validateTitle,
                    ),
                    const SizedBox(height: 8),
                    // === Deskripsi ===
                    TextFormField(
                      controller: _description,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: _decoration(
                        'Deskripsi',
                        hint: 'Apa yang kamu lakukan dan pelajari?',
                      ),
                      validator: (value) => _required(value, 'Deskripsi'),
                    ),
                    const SizedBox(height: 16),
                    // === Kategori ===
                    DropdownButtonFormField<String>(
                      initialValue: _category,
                      decoration: _decoration('Kategori'),
                      items: [
                        for (final entry
                            in ExperienceFormPage.categories.entries)
                          DropdownMenuItem(
                            value: entry.key,
                            child: Text(entry.value),
                          ),
                      ],
                      onChanged: (value) => setState(() => _category = value!),
                    ),
                    const SizedBox(height: 16),
                    // === URL gambar ===
                    TextFormField(
                      controller: _thumbnail,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      decoration: _decoration(
                        'URL gambar (opsional)',
                        hint: 'https://contoh.com/foto.jpg',
                      ),
                      validator: _validateThumbnail,
                    ),
                    const SizedBox(height: 16),
                    // === Tanggal selesai ===
                    TextFormField(
                      controller: _endDateText,
                      readOnly: true, // diisi lewat kalender, bukan diketik
                      onTap: _pickEndDate,
                      decoration:
                          _decoration(
                            'Tanggal selesai (opsional)',
                            hint: 'Masih berjalan',
                            helper:
                                'Kosongkan jika pengalaman ini masih berjalan.',
                          ).copyWith(
                            prefixIcon: const Icon(Icons.event),
                            suffixIcon: _endDate == null
                                ? null
                                : IconButton(
                                    tooltip: 'Hapus tanggal',
                                    icon: const Icon(Icons.clear),
                                    onPressed: () => _setEndDate(null),
                                  ),
                          ),
                      validator: _validateEndDate,
                    ),
                    const SizedBox(height: 24),
                    // === Tombol Simpan ===
                    FilledButton.icon(
                      onPressed: _save,
                      icon: const Icon(Icons.save),
                      label: const Text('Simpan'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Satu baris di dialog ringkasan: label tebal di atas, isinya di bawah.
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
