import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';

/// Detail satu proyek. Gambar hanya ditampilkan kalau thumbnail-nya ada.
class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({required this.project, super.key});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(project.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (project.imageUrl.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                project.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  height: 120,
                  child: Center(child: Icon(Icons.broken_image, size: 48)),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(project.title, style: textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(project.description, style: textTheme.bodyLarge),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.star, size: 20),
              const SizedBox(width: 4),
              Text('${project.starCount} star'),
            ],
          ),
          if (project.starredByNames.isNotEmpty)
            Text('Starred by: ${project.starredByNames}'),
        ],
      ),
    );
  }
}
