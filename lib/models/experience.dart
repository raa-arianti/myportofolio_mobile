import 'package:json_annotation/json_annotation.dart';

part 'experience.g.dart';

/// Satu pengalaman (Experience), sama bentuknya dengan `ExperienceSerializer`
/// di Django (`/api/v1/experience/`).
///
/// Field yang ditulis klien saat POST: `title`, `description`, `category`,
/// `thumbnail`, dan `ended_at`. Sisanya dihitung atau diisi server, jadi
/// ditandai `includeToJson: false` supaya tidak ikut terkirim.
@JsonSerializable(fieldRename: FieldRename.snake)
class Experience {
  const Experience({
    required this.title,
    required this.description,
    this.category = 'full-time',
    this.thumbnail,
    this.endedAt,
    this.id,
    this.categoryLabel = '',
    this.startedAt,
    this.isOngoing = true,
    this.starCount = 0,
    this.isStarred = false,
    this.starredByNames = '',
  });

  factory Experience.fromJson(Map<String, dynamic> json) =>
      _$ExperienceFromJson(json);

  /// UUID dibuat oleh Django.
  @JsonKey(includeToJson: false)
  final String? id;

  final String title;
  final String description;

  /// Kode kategori, misalnya `internship` atau `full-time`.
  @JsonKey(defaultValue: 'full-time')
  final String category;

  /// URL gambar (opsional). `null` berarti tidak ada gambar.
  final String? thumbnail;

  /// Tanggal selesai. `null` berarti pengalaman masih berjalan.
  final DateTime? endedAt;

  // ---------- Field yang hanya dibaca (diisi server) ----------

  /// Label kategori yang siap ditampilkan, misalnya `Full-Time`.
  @JsonKey(includeToJson: false, defaultValue: '')
  final String categoryLabel;

  /// Diisi otomatis oleh Django (`auto_now_add`).
  @JsonKey(includeToJson: false)
  final DateTime? startedAt;

  @JsonKey(includeToJson: false, defaultValue: true)
  final bool isOngoing;

  @JsonKey(includeToJson: false, defaultValue: 0)
  final int starCount;

  @JsonKey(includeToJson: false, defaultValue: false)
  final bool isStarred;

  @JsonKey(includeToJson: false, defaultValue: '')
  final String starredByNames;

  Map<String, dynamic> toJson() => _$ExperienceToJson(this);
}
