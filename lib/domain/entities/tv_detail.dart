import 'package:expert_app/domain/entities/genre.dart';
import 'package:expert_app/domain/entities/media.dart';
import 'package:expert_app/domain/entities/season.dart';
import 'package:equatable/equatable.dart';

class TvDetail extends Equatable {
  TvDetail({
    required this.adult,
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.firstAirDate,
    required this.lastAirDate,
    required this.name,
    required this.voteAverage,
    required this.voteCount,
    required this.seasons,
  });

  final bool adult;
  final String? backdropPath;
  final List<Genre> genres;
  final int id;
  final String originalName;
  final String overview;
  final String posterPath;
  final String firstAirDate;
  final String lastAirDate;
  final String name;
  final double voteAverage;
  final int voteCount;
  final List<Season>? seasons;

  Media toMedia() {
    return Media(
      id: this.id,
      title: this.name,
      posterPath: this.posterPath,
      overview: this.overview,
      mediaType: 'tv',
    );
  }

  @override
  List<Object?> get props => [
    adult,
    backdropPath,
    genres,
    id,
    originalName,
    overview,
    posterPath,
    firstAirDate,
    lastAirDate,
    name,
    voteAverage,
    voteCount,
    seasons,
  ];
}
