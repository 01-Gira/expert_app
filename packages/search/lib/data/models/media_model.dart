import 'package:search/domain/entities/media.dart';
import 'package:equatable/equatable.dart';

class MediaModel extends Equatable {
  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;
  final String mediaType;

  const MediaModel({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.mediaType,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) => MediaModel(
    id: json["id"],
    title: json["media_type"] == 'tv' ? json["name"] : json["title"],
    posterPath: json["poster_path"],
    overview: json["overview"],
    mediaType: json["media_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "poster_path": posterPath,
    "overview": overview,
    "media_type": mediaType,
  };

  Media toEntity() {
    return Media(
      id: id,
      title: title,
      posterPath: posterPath,
      overview: overview,
      mediaType: mediaType,
    );
  }

  @override
  List<Object?> get props => [id, title, posterPath, overview, mediaType];
}
