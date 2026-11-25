import 'package:json_annotation/json_annotation.dart';
import 'package:myportofolio_mobile/config.dart';

part 'project.g.dart';

/// Proyek portofolio, sama bentuknya dengan `ProjectSerializer` di Django.
///
/// Serializer backend-ku berisi `id`, `title`, `description`, `thumbnail`
/// (nama file di `static/img/projects/`), dan tiga field star yang hanya bisa
/// dibaca. Model ini mengikuti skema itu, bukan field mock form Tutorial 09.
@JsonSerializable(fieldRename: FieldRename.snake)
class Project {
  const Project({
    required this.title,
    required this.description,
    required this.thumbnail,
    this.id,
    this.starCount = 0,
    this.isStarred = false,
    this.starredByNames = '',
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  /// UUID dibuat oleh Django, jadi tidak ikut dikirim saat POST.
  @JsonKey(includeToJson: false)
  final String? id;
  final String title;
  final String description;

  @JsonKey(defaultValue: '')
  final String thumbnail;

  // Field star dihitung server (read-only), jadi juga tidak dikirim saat POST.
  @JsonKey(includeToJson: false, defaultValue: 0)
  final int starCount;
  @JsonKey(includeToJson: false, defaultValue: false)
  final bool isStarred;
  @JsonKey(includeToJson: false, defaultValue: '')
  final String starredByNames;

  /// URL gambar kartu, atau string kosong kalau thumbnail belum diisi.
  String get imageUrl =>
      thumbnail.isEmpty ? '' : '$apiBaseUrl/static/img/projects/$thumbnail';

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
