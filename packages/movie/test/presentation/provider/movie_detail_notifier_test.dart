import 'package:dartz/dartz.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:core/common/failure.dart';
import 'package:movie/presentation/provider/movie_detail_notifier.dart';
import 'package:core/common/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieDetailNotifier provider;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    provider =
        MovieDetailNotifier(
          getMovieDetail: mockGetMovieDetail,
          getMovieRecommendations: mockGetMovieRecommendations,
        )..addListener(() {
          listenerCallCount += 1;
        });
  });

  final tId = 1;

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
  final tMovies = <Movie>[tMovie];

  void arrangeUsecase() {
    when(
      mockGetMovieDetail.execute(tId),
    ).thenAnswer((_) async => Right(testMovieDetail));
    when(
      mockGetMovieRecommendations.execute(tId),
    ).thenAnswer((_) async => Right(tMovies));
  }

  group('Get Movie Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      arrangeUsecase();
      // act
      await provider.fetchMovieDetail(tId);
      // assert
      verify(mockGetMovieDetail.execute(tId));
      verify(mockGetMovieRecommendations.execute(tId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      arrangeUsecase();
      // act
      provider.fetchMovieDetail(tId);
      // assert
      expect(provider.movieState, RequestState.loading);
      expect(listenerCallCount, 1);
    });

    test('should change movie when data is gotten successfully', () async {
      // arrange
      arrangeUsecase();
      // act
      await provider.fetchMovieDetail(tId);
      // assert
      expect(provider.movieState, RequestState.loaded);
      expect(provider.movie, testMovieDetail);
      expect(listenerCallCount, 3);
    });

    test(
      'should change recommendation movies when data is gotten successfully',
      () async {
        // arrange
        arrangeUsecase();
        // act
        await provider.fetchMovieDetail(tId);
        // assert
        expect(provider.movieState, RequestState.loaded);
        expect(provider.movieRecommendations, tMovies);
      },
    );
  });

  group('Get Movie Recommendations', () {
    test('should get data from the usecase', () async {
      // arrange
      arrangeUsecase();
      // act
      await provider.fetchMovieDetail(tId);
      // assert
      verify(mockGetMovieRecommendations.execute(tId));
      expect(provider.movieRecommendations, tMovies);
    });

    test(
      'should update recommendation state when data is gotten successfully',
      () async {
        // arrange
        arrangeUsecase();
        // act
        await provider.fetchMovieDetail(tId);
        // assert
        expect(provider.recommendationState, RequestState.loaded);
        expect(provider.movieRecommendations, tMovies);
      },
    );

    test('should update error message when request in successful', () async {
      // arrange
      when(
        mockGetMovieDetail.execute(tId),
      ).thenAnswer((_) async => Right(testMovieDetail));
      when(
        mockGetMovieRecommendations.execute(tId),
      ).thenAnswer((_) async => Left(ServerFailure('Failed')));
      // act
      await provider.fetchMovieDetail(tId);
      // assert
      expect(provider.recommendationState, RequestState.error);
      expect(provider.message, 'Failed');
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockGetMovieDetail.execute(tId),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(
        mockGetMovieRecommendations.execute(tId),
      ).thenAnswer((_) async => Right(tMovies));
      // act
      await provider.fetchMovieDetail(tId);
      // assert
      expect(provider.movieState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
