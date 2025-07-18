import 'package:dartz/dartz.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:core/common/failure.dart';
import 'package:movie/presentation/provider/movie_list_notifier.dart';
import 'package:core/common/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieListNotifier provider;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    provider =
        MovieListNotifier(
          getNowPlayingMovies: mockGetNowPlayingMovies,
          getPopularMovies: mockGetPopularMovies,
          getTopRatedMovies: mockGetTopRatedMovies,
        )..addListener(() {
          listenerCallCount += 1;
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

  group('now playing movies', () {
    test('initialState should be Empty', () {
      expect(provider.nowPlayingState, equals(RequestState.empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(
        mockGetNowPlayingMovies.execute(),
      ).thenAnswer((_) async => Right(tMovieList));
      // act
      provider.fetchNowPlayingMovies();
      // assert
      verify(mockGetNowPlayingMovies.execute());
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(
        mockGetNowPlayingMovies.execute(),
      ).thenAnswer((_) async => Right(tMovieList));
      // act
      provider.fetchNowPlayingMovies();
      // assert
      expect(provider.nowPlayingState, RequestState.loading);
    });

    test('should change movies when data is gotten successfully', () async {
      // arrange
      when(
        mockGetNowPlayingMovies.execute(),
      ).thenAnswer((_) async => Right(tMovieList));
      // act
      await provider.fetchNowPlayingMovies();
      // assert
      expect(provider.nowPlayingState, RequestState.loaded);
      expect(provider.nowPlayingMovies, tMovieList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockGetNowPlayingMovies.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchNowPlayingMovies();
      // assert
      expect(provider.nowPlayingState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(
        mockGetPopularMovies.execute(),
      ).thenAnswer((_) async => Right(tMovieList));
      // act
      provider.fetchPopularMovies();
      // assert
      expect(provider.popularMoviesState, RequestState.loading);
      // verify(provider.setState(RequestState.loading));
    });

    test(
      'should change movies data when data is gotten successfully',
      () async {
        // arrange
        when(
          mockGetPopularMovies.execute(),
        ).thenAnswer((_) async => Right(tMovieList));
        // act
        await provider.fetchPopularMovies();
        // assert
        expect(provider.popularMoviesState, RequestState.loaded);
        expect(provider.popularMovies, tMovieList);
        expect(listenerCallCount, 2);
      },
    );

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockGetPopularMovies.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopularMovies();
      // assert
      expect(provider.popularMoviesState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(
        mockGetTopRatedMovies.execute(),
      ).thenAnswer((_) async => Right(tMovieList));
      // act
      provider.fetchTopRatedMovies();
      // assert
      expect(provider.topRatedMoviesState, RequestState.loading);
    });

    test(
      'should change movies data when data is gotten successfully',
      () async {
        // arrange
        when(
          mockGetTopRatedMovies.execute(),
        ).thenAnswer((_) async => Right(tMovieList));
        // act
        await provider.fetchTopRatedMovies();
        // assert
        expect(provider.topRatedMoviesState, RequestState.loaded);
        expect(provider.topRatedMovies, tMovieList);
        expect(listenerCallCount, 2);
      },
    );

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockGetTopRatedMovies.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRatedMovies();
      // assert
      expect(provider.topRatedMoviesState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
