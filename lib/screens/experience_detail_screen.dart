import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

/// Menampilkan semua field satu Experience. Tombol hapus (fitur tambahan)
/// memanggil `DELETE /api/v1/experience/<id>/` dan wajib login.
///
/// Mengembalikan `true` lewat `Navigator.pop` kalau entri dihapus, supaya
/// daftar di belakangnya memuat ulang.
class ExperienceDetailScreen extends StatefulWidget {
  const ExperienceDetailScreen({required this.experience, super.key});

  final Experience experience;

  @override
  State<ExperienceDetailScreen> createState() => _ExperienceDetailScreenState();
}

class _ExperienceDetailScreenState extends State<ExperienceDetailScreen> {
  bool _isDeleting = false;

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus experience?'),
        content: Text('"${widget.experience.title}" akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    if (!await ensureLoggedIn(context)) return;
    if (!mounted) return;

    final auth = context.read<AuthState>();
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _isDeleting = true);
    try {
      await context.read<ApiClient>().deleteExperience(
        widget.experience.id!,
        token: auth.token!,
      );
      if (!mounted) return;
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Experience dihapus.')));
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (e.statusCode == 401) await auth.logout();
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(_deleteError(e.statusCode))));
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  static String _deleteError(int statusCode) => switch (statusCode) {
    401 => 'Sesi berakhir, silakan login ulang.',
    403 => 'Hanya pemilik portofolio yang boleh menghapus.',
    404 => 'Experience ini sudah tidak ada.',
    _ => 'Gagal menghapus (status $statusCode).',
  };

  String _formatDate(DateTime? date) => date == null
      ? '-'
      : MaterialLocalizations.of(context).formatMediumDate(date.toLocal());

  @override
  Widget build(BuildContext context) {
    final experience = widget.experience;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final thumbnail = experience.thumbnail ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Experience'),
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Hapus',
            onPressed: _isDeleting ? null : _delete,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (thumbnail.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                thumbnail,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  height: 120,
                  child: Center(child: Icon(Icons.broken_image, size: 48)),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(experience.title, style: textTheme.headlineSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              Chip(label: Text(experience.categoryLabel)),
              Chip(
                label: Text(
                  experience.isOngoing ? 'Masih berjalan' : 'Sudah selesai',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(experience.description, style: textTheme.bodyLarge),
          const Divider(height: 32),
          _Field('Mulai', _formatDate(experience.startedAt)),
          _Field(
            'Selesai',
            experience.endedAt == null
                ? 'Masih berjalan'
                : _formatDate(experience.endedAt),
          ),
          _Field('URL gambar', thumbnail.isEmpty ? '-' : thumbnail),
          _Field('Jumlah star', '${experience.starCount}'),
          _Field(
            'Di-star oleh',
            experience.starredByNames.isEmpty ? '-' : experience.starredByNames,
          ),
        ],
      ),
    );
  }
}

/// Satu baris label dan isi di halaman detail.
class _Field extends StatelessWidget {
  const _Field(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
