import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:movie/data/models/genre_model.dart';
import 'package:movie/data/models/movie_detail_model.dart';
import 'package:movie/data/models/movie_model.dart';
import 'package:movie/data/repositories/movie_repository_impl.dart';
import 'package:core/common/exception.dart';
import 'package:core/common/failure.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieRepositoryImpl repository;
  late MockMovieRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockMovieRemoteDataSource();
    repository = MovieRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  final tMovieModel = MovieModel(
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

  final tMovie = Movie(
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

  final tMovieModelList = <MovieModel>[tMovieModel];
  final tMovieList = <Movie>[tMovie];

  group('Now Playing Movies', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getNowPlayingMovies(),
        ).thenAnswer((_) async => tMovieModelList);
        // act
        final result = await repository.getNowPlayingMovies();
        // assert
        verify(mockRemoteDataSource.getNowPlayingMovies());
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tMovieList);
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getNowPlayingMovies(),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getNowPlayingMovies();
        // assert
        verify(mockRemoteDataSource.getNowPlayingMovies());
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getNowPlayingMovies(),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getNowPlayingMovies();
        // assert
        verify(mockRemoteDataSource.getNowPlayingMovies());
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Popular Movies', () {
    test(
      'should return movie list when call to data source is success',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getPopularMovies(),
        ).thenAnswer((_) async => tMovieModelList);
        // act
        final result = await repository.getPopularMovies();
        // assert
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tMovieList);
      },
    );

    test(
      'should return server failure when call to data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getPopularMovies(),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getPopularMovies();
        // assert
        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return connection failure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getPopularMovies(),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getPopularMovies();
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Top Rated Movies', () {
    test(
      'should return movie list when call to data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedMovies(),
        ).thenAnswer((_) async => tMovieModelList);
        // act
        final result = await repository.getTopRatedMovies();
        // assert
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tMovieList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedMovies(),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTopRatedMovies();
        // assert
        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedMovies(),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTopRatedMovies();
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Get Movie Detail', () {
    final tId = 1;
    final tMovieResponse = MovieDetailResponse(
      adult: false,
      backdropPath: 'backdropPath',
      budget: 100,
      genres: [GenreModel(id: 1, name: 'Action')],
      homepage: "https://google.com",
      id: 1,
      imdbId: 'imdb1',
      originalLanguage: 'en',
      originalTitle: 'originalTitle',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      revenue: 12000,
      runtime: 120,
      status: 'Status',
      tagline: 'Tagline',
      title: 'title',
      video: false,
      voteAverage: 1,
      voteCount: 1,
    );

    test(
      'should return Movie data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getMovieDetail(tId),
        ).thenAnswer((_) async => tMovieResponse);
        // act
        final result = await repository.getMovieDetail(tId);
        // assert
        verify(mockRemoteDataSource.getMovieDetail(tId));
        expect(result, equals(Right(testMovieDetail)));
      },
    );

    test(
      'should return Server Failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getMovieDetail(tId),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getMovieDetail(tId);
        // assert
        verify(mockRemoteDataSource.getMovieDetail(tId));
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getMovieDetail(tId),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getMovieDetail(tId);
        // assert
        verify(mockRemoteDataSource.getMovieDetail(tId));
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Get Movie Recommendations', () {
    final tMovieList = <MovieModel>[];
    final tId = 1;

    test('should return data (movie list) when the call is successful', () async {
      // arrange
      when(
        mockRemoteDataSource.getMovieRecommendations(tId),
      ).thenAnswer((_) async => tMovieList);
      // act
      final result = await repository.getMovieRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getMovieRecommendations(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tMovieList));
    });

    test(
      'should return server failure when call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getMovieRecommendations(tId),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getMovieRecommendations(tId);
        // assertbuild runner
        verify(mockRemoteDataSource.getMovieRecommendations(tId));
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getMovieRecommendations(tId),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getMovieRecommendations(tId);
        // assert
        verify(mockRemoteDataSource.getMovieRecommendations(tId));
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Seach Movies', () {
    final tQuery = 'spiderman';

    test(
      'should return movie list when call to data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchMovies(tQuery),
        ).thenAnswer((_) async => tMovieModelList);
        // act
        final result = await repository.searchMovies(tQuery);
        // assert
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tMovieList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchMovies(tQuery),
        ).thenThrow(ServerException());
        // act
        final result = await repository.searchMovies(tQuery);
        // assert
        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchMovies(tQuery),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.searchMovies(tQuery);
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });
}
