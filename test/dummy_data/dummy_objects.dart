import 'package:movie/domain/entities/movie.dart';
import 'package:tv/domain/entities/tv.dart';

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
