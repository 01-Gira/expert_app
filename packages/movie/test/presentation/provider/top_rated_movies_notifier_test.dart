import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:core/common/state_enum.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/provider/top_rated_movies_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late TopRatedMoviesNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    notifier = TopRatedMoviesNotifier(getTopRatedMovies: mockGetTopRatedMovies)
      ..addListener(() {
        listenerCallCount++;
      });
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovieList = <Movie>[tMovie];

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(
      mockGetTopRatedMovies.execute(),
    ).thenAnswer((_) async => Right(tMovieList));
    // act
    notifier.fetchTopRatedMovies();
    // assert
    expect(notifier.state, RequestState.loading);
    expect(listenerCallCount, 1);
  });

  test('should change movies data when data is gotten successfully', () async {
    // arrange
    when(
      mockGetTopRatedMovies.execute(),
    ).thenAnswer((_) async => Right(tMovieList));
    // act
    await notifier.fetchTopRatedMovies();
    // assert
    expect(notifier.state, RequestState.loaded);
    expect(notifier.movies, tMovieList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(
      mockGetTopRatedMovies.execute(),
    ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchTopRatedMovies();
    // assert
    expect(notifier.state, RequestState.error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
