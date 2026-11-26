import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/screens/experience_detail_screen.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

/// Daftar Experience dari `GET /api/v1/experience/` (publik, tanpa login).
class ExperienceListScreen extends StatefulWidget {
  const ExperienceListScreen({super.key});

  @override
  State<ExperienceListScreen> createState() => _ExperienceListScreenState();
}

class _ExperienceListScreenState extends State<ExperienceListScreen> {
  late Future<List<Experience>> _experiencesFuture;

  @override
  void initState() {
    super.initState();
    // Dibuat sekali di initState. Kalau dibuat di build, setiap rebuild
    // (misalnya saat drawer dibuka) akan mengirim request baru.
    _experiencesFuture = context.read<ApiClient>().getExperiences();
  }

  Future<void> _reload() async {
    final future = context.read<ApiClient>().getExperiences();
    setState(() {
      _experiencesFuture = future;
    });
    await future;
  }

  /// Buka form (wajib login), lalu muat ulang daftar setelah kembali supaya
  /// entri yang baru dibuat langsung muncul.
  Future<void> _openForm() async {
    if (!await ensureLoggedIn(context)) return;
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ExperienceFormPage(openedFromList: true),
      ),
    );
    if (mounted) await _reload();
  }

  Future<void> _openDetail(Experience experience) async {
    final deleted = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => ExperienceDetailScreen(experience: experience),
      ),
    );
    if (deleted == true && mounted) await _reload();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Experience'),
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Tambah Experience',
        onPressed: _openForm,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Experience>>(
        future: _experiencesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Gagal memuat experience: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _reload,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final experiences = snapshot.data ?? const <Experience>[];
          if (experiences.isEmpty) {
            // Tetap bisa ditarik untuk refresh walaupun daftarnya kosong.
            return RefreshIndicator(
              onRefresh: _reload,
              child: const SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 120),
                  child: Center(child: Text('Belum ada experience.')),
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              // Ruang di bawah supaya kartu terakhir tidak tertutup tombol +.
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 88),
              itemCount: experiences.length,
              itemBuilder: (context, index) {
                final experience = experiences[index];
                return Card(
                  child: ListTile(
                    leading: Icon(
                      experience.isOngoing
                          ? Icons.work
                          : Icons.work_history_outlined,
                      color: colors.primary,
                    ),
                    title: Text(experience.title),
                    subtitle: Text(
                      '${experience.categoryLabel}'
                      '${experience.isOngoing ? ' · Masih berjalan' : ''}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 18),
                        Text('${experience.starCount}'),
                      ],
                    ),
                    onTap: () => _openDetail(experience),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
