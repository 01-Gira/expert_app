import 'package:expert_app/data/models/watchlist_table.dart';
import 'package:expert_app/domain/entities/genre.dart';
import 'package:expert_app/domain/entities/media.dart';
import 'package:expert_app/domain/entities/movie.dart';
import 'package:expert_app/domain/entities/movie_detail.dart';
import 'package:expert_app/domain/entities/season.dart';
import 'package:expert_app/domain/entities/tv.dart';
import 'package:expert_app/domain/entities/tv_detail.dart';

// === MOVIE DUMMIES ===

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

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

final testTvDetail = TvDetail(
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

// === WATCHLIST & MEDIA DUMMIES ===

final testWatchlistItem = Media(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
  mediaType: 'movie',
);

final testWatchlistItems = [testWatchlistItem];

final testWatchlistTable = WatchlistTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
  mediaType: 'movie',
);

final testWatchlistMap = {
  'id': 1,
  'title': 'title',
  'posterPath': 'posterPath',
  'overview': 'overview',
  'mediaType': 'movie',
};
