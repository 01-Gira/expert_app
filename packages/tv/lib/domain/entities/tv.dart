import 'package:equatable/equatable.dart';

class Tv extends Equatable {
  const Tv({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.firstAirDate,
    required this.name,
    required this.voteAverage,
    required this.voteCount,
  });

  final bool? adult;
  final String? backdropPath;
  final List<int>? genreIds;
  final int id;
  final String? originalName;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final String? firstAirDate;
  final String? name;
  final double? voteAverage;
  final int? voteCount;

  @override
  List<Object?> get props => [
    adult,
    backdropPath,
    genreIds,
    id,
    originalName,
    overview,
    popularity,
    posterPath,
    firstAirDate,
    name,
    voteAverage,
    voteCount,
  ];
}
