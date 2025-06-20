import 'package:movie/domain/entities/genre.dart';
import 'package:tv/domain/entities/season.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';

// === TV DUMMIES ===

final testTv = Tv(
  adult: false,
  backdropPath: '/path.jpg',
  genreIds: [1, 2, 3],
  id: 1,
  originalName: 'Original Name',
  overview: 'Overview',
  popularity: 1.0,
  posterPath: '/path.jpg',
  firstAirDate: '2023-01-01',
  name: 'Test TV',
  voteAverage: 1.0,
  voteCount: 1,
);

final testTvList = <Tv>[testTv];

const testTvDetail = TvDetail(
  adult: false,
  lastAirDate: '2022-01-01',
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalName: 'originalName',
  overview: 'overview',
  posterPath: 'posterPath',
  firstAirDate: '2022-01-01',
  name: 'name',
  voteAverage: 1,
  voteCount: 1,
  seasons: [
    Season(
      airDate: '2022-01-01',
      episodeCount: 10,
      id: 1,
      name: 'Season 1',
      overview: 'Overview of Season 1',
      posterPath: 'posterPath',
      seasonNumber: 1,
      voteAverage: 8.0,
    ),
  ],
);
