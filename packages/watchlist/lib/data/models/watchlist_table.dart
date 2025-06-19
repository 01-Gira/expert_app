import 'package:search/domain/entities/media.dart';
import 'package:equatable/equatable.dart';

class WatchlistTable extends Equatable {
  final int id;
  final String title;
  final String posterPath;
  final String overview;
  final String mediaType;

  const WatchlistTable({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.mediaType,
  });

  factory WatchlistTable.fromEntity(Media media) => WatchlistTable(
    id: media.id,
    title: media.title ?? '',
    posterPath: media.posterPath ?? '',
    overview: media.overview ?? '',
    mediaType: media.mediaType,
  );

  factory WatchlistTable.fromMap(Map<String, dynamic> map) => WatchlistTable(
    id: map['id'],
    title: map['title'],
    posterPath: map['posterPath'],
    overview: map['overview'],
    mediaType: map['mediaType'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'posterPath': posterPath,
    'overview': overview,
    'mediaType': mediaType,
  };

  Media toEntity() => Media(
    id: id,
    overview: overview,
    posterPath: posterPath,
    title: title,
    mediaType: mediaType,
  );

  @override
  List<Object?> get props => [id, title, posterPath, overview, mediaType];
}
