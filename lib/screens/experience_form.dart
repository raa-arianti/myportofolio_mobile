import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/screens/experience_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

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
/// Saat Simpan ditekan dengan isian valid, data dikirim ke Django lewat
/// `POST /api/v1/experience/` memakai token login (lihat [ensureLoggedIn]).
class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({this.openedFromList = false, super.key});

  /// `true` kalau form dibuka dari [ExperienceListScreen]. Setelah simpan,
  /// "Lihat daftar" cukup kembali ke daftar itu (yang lalu memuat ulang),
  /// bukan membuka daftar kedua.
  final bool openedFromList;

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
  bool _isSubmitting = false;

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

  Future<void> _save() async {
    // validate() menjalankan semua validator; pesan error muncul di kolomnya.
    if (!_formKey.currentState!.validate()) return;
    // Halaman ini bisa dibuka lewat jalur yang tidak dijaga, jadi saat kirim
    // tetap dipastikan sudah login.
    if (!await ensureLoggedIn(context)) return;
    if (!mounted) return;

    final auth = context.read<AuthState>();
    final thumbnail = _thumbnail.text.trim();
    final end = _endDate;
    final newExperience = Experience(
      title: _title.text.trim(),
      description: _description.text.trim(),
      category: _category,
      thumbnail: thumbnail.isEmpty ? null : thumbnail,
      // Dikirim sebagai tanggal UTC (tengah malam) supaya Django tidak
      // menggeser harinya karena zona waktu.
      endedAt: end == null ? null : DateTime.utc(end.year, end.month, end.day),
    );

    setState(() => _isSubmitting = true);
    try {
      final created = await context.read<ApiClient>().createExperience(
        newExperience,
        token: auth.token!,
      );
      if (!mounted) return;
      _showCreatedDialog(created);
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.statusCode == 401) {
        // Token sudah dicabut atau kedaluwarsa: hapus sesi, lalu minta login ulang.
        await auth.logout();
        if (!mounted) return;
        _showError('Sesi berakhir, silakan login ulang.');
        await ensureLoggedIn(context);
      } else {
        _showError(switch (e.statusCode) {
          403 => 'Hanya pemilik portofolio yang boleh menambah experience.',
          400 => 'Data ditolak server. Periksa kembali isianmu.',
          _ => 'Gagal menyimpan (status ${e.statusCode}).',
        });
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Ringkasan entri yang sudah tersimpan di Django, dengan pilihan menambah
  /// lagi atau membuka daftar Experience (yang memuat data terbaru).
  void _showCreatedDialog(Experience created) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Experience berhasil disimpan!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _SummaryRow('Judul', created.title),
                _SummaryRow('Deskripsi', created.description),
                _SummaryRow(
                  'Kategori',
                  created.categoryLabel.isEmpty
                      ? ExperienceFormPage.categories[created.category] ??
                            created.category
                      : created.categoryLabel,
                ),
                _SummaryRow('URL gambar', created.thumbnail ?? '(tidak ada)'),
                _SummaryRow(
                  'Tanggal selesai',
                  _endDate == null ? 'Masih berjalan' : _endDateText.text,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Tambah lagi'),
              onPressed: () {
                Navigator.pop(dialogContext); // tutup dialog, kembali ke form
                _resetForm();
              },
            ),
            FilledButton(
              child: const Text('Lihat daftar'),
              onPressed: () {
                Navigator.pop(dialogContext);
                if (widget.openedFromList) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExperienceListScreen(),
                    ),
                  );
                }
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
                      onPressed: _isSubmitting ? null : _save,
                      icon: _isSubmitting
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
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
