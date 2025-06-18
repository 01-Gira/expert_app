import 'package:expert_app/data/models/genre_model.dart';
import 'package:expert_app/data/models/season_model.dart';
import 'package:expert_app/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

class TvDetailResponse extends Equatable {
  TvDetailResponse({
    required this.adult,
    required this.backdropPath,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.originalLanguage,
    required this.name,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.firstAirDate,
    required this.lastAirDate,
    required this.status,
    required this.tagline,
    required this.voteAverage,
    required this.voteCount,
    required this.seasons,
  });

  final bool adult;
  final String? backdropPath;
  final List<GenreModel> genres;
  final String homepage;
  final int id;
  final String originalLanguage;
  final String name;
  final String originalName;
  final String overview;
  final double popularity;
  final String posterPath;
  final String firstAirDate;
  final String lastAirDate;
  final String status;
  final String tagline;
  final double voteAverage;
  final int voteCount;
  final List<SeasonModel>? seasons;

  factory TvDetailResponse.fromJson(Map<String, dynamic> json) =>
      TvDetailResponse(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        genres: List<GenreModel>.from(
          json["genres"].map((x) => GenreModel.fromJson(x)),
        ),
        homepage: json["homepage"],
        id: json["id"],
        lastAirDate: json["last_air_date"],
        name: json["name"],
        originalLanguage: json["original_language"],
        originalName: json["original_name"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"],
        firstAirDate: json["first_air_date"],
        status: json["status"],
        tagline: json["tagline"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
        seasons: json["seasons"] == null
            ? []
            : List<SeasonModel>.from(
                json["seasons"].map((x) => SeasonModel.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "adult": adult,
    "backdrop_path": backdropPath,
    "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
    "homepage": homepage,
    "id": id,
    "original_language": originalLanguage,
    "original_name": originalName,
    "overview": overview,
    "popularity": popularity,
    "poster_path": posterPath,
    "first_air_date": firstAirDate,
    "last_air_date": lastAirDate,
    "status": status,
    "tagline": tagline,
    "vote_average": voteAverage,
    "vote_count": voteCount,
    "seasons": seasons == null
        ? []
        : List<dynamic>.from(seasons!.map((x) => x.toJson())),
  };

  TvDetail toEntity() {
    return TvDetail(
      adult: this.adult,
      backdropPath: this.backdropPath,
      genres: this.genres.map((genre) => genre.toEntity()).toList(),
      id: this.id,
      name: this.name,
      originalName: this.originalName,
      overview: this.overview,
      posterPath: this.posterPath,
      firstAirDate: this.firstAirDate,
      lastAirDate: this.lastAirDate,
      voteAverage: this.voteAverage,
      voteCount: this.voteCount,
      seasons: this.seasons?.map((season) => season.toEntity()).toList() ?? [],
    );
  }

  @override
  List<Object?> get props => [
    adult,
    backdropPath,
    genres,
    homepage,
    id,
    name,
    originalLanguage,
    originalName,
    overview,
    popularity,
    posterPath,
    firstAirDate,
    lastAirDate,
    status,
    tagline,
    voteAverage,
    voteCount,
    seasons,
  ];
}
