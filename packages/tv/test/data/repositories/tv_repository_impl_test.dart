import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:movie/data/models/genre_model.dart';
import 'package:tv/data/models/season_model.dart';
import 'package:tv/data/models/tv_detail_model.dart';
import 'package:tv/data/models/tv_model.dart';
import 'package:tv/data/repositories/tv_repository_impl.dart';
import 'package:core/common/exception.dart';
import 'package:core/common/failure.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvRepositoryImpl repository;
  late MockTvRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvRemoteDataSource();
    repository = TvRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  final tTvModel = TvModel(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [10759, 9648],
    id: 557,
    originalName: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43AAnbjSbBgu3G9Ammg.jpg',
    firstAirDate: '2003-01-21',
    name: 'Spider-Man',
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tTv = tTvModel.toEntity();
  final tTvModelList = <TvModel>[tTvModel];
  final tTvList = <Tv>[tTv];

  group('On The Air Tvs', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getOnTheAirTvs(),
        ).thenAnswer((_) async => tTvModelList);
        // act
        final result = await repository.getOnTheAirTvs();
        // assert
        verify(mockRemoteDataSource.getOnTheAirTvs());
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvList);
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getOnTheAirTvs(),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getOnTheAirTvs();
        // assert
        verify(mockRemoteDataSource.getOnTheAirTvs());
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getOnTheAirTvs(),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getOnTheAirTvs();
        // assert
        verify(mockRemoteDataSource.getOnTheAirTvs());
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Popular Tvs', () {
    test('should return tv list when call to data source is success', () async {
      // arrange
      when(
        mockRemoteDataSource.getPopularTvs(),
      ).thenAnswer((_) async => tTvModelList);
      // act
      final result = await repository.getPopularTvs();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test(
      'should return server failure when call to data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getPopularTvs()).thenThrow(ServerException());
        // act
        final result = await repository.getPopularTvs();
        // assert
        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return connection failure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getPopularTvs(),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getPopularTvs();
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Top Rated Tvs', () {
    test(
      'should return tv list when call to data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedTvs(),
        ).thenAnswer((_) async => tTvModelList);
        // act
        final result = await repository.getTopRatedTvs();
        // assert
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedTvs(),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTopRatedTvs();
        // assert
        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedTvs(),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTopRatedTvs();
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Get Tv Detail', () {
    final tId = 1;
    final tTvResponse = TvDetailResponse(
      adult: false,
      backdropPath: 'backdropPath',
      genres: [GenreModel(id: 1, name: 'Action')],
      homepage: "https://google.com",
      id: 1,
      originalLanguage: 'en',
      originalName: 'originalName',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      firstAirDate: 'firstAirDate',
      lastAirDate: 'lastAirDate',
      status: 'Status',
      tagline: 'Tagline',
      name: 'name',
      voteAverage: 1,
      voteCount: 1,
      seasons: [
        SeasonModel(
          airDate: 'airDate',
          episodeCount: 1,
          id: 1,
          name: 'name',
          overview: 'overview',
          posterPath: 'posterPath',
          seasonNumber: 1,
          voteAverage: 1,
        ),
      ],
    );

    test(
      'should return Tv detail when the call to remote data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvDetail(tId),
        ).thenAnswer((_) async => tTvResponse);
        // act
        final result = await repository.getTvDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTvDetail(tId));
        expect(result, equals(Right(tTvResponse.toEntity())));
      },
    );

    test(
      'should return Server Failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvDetail(tId),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTvDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTvDetail(tId));
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvDetail(tId),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTvDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTvDetail(tId));
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Get Tv Recommendations', () {
    final tTvList = <TvModel>[];
    final tId = 1;

    test('should return data (tv list) when the call is successful', () async {
      // arrange
      when(
        mockRemoteDataSource.getTvRecommendations(tId),
      ).thenAnswer((_) async => tTvList);
      // act
      final result = await repository.getTvRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getTvRecommendations(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tTvList));
    });

    test(
      'should return server failure when call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvRecommendations(tId),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTvRecommendations(tId);
        // assertbuild runner
        verify(mockRemoteDataSource.getTvRecommendations(tId));
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvRecommendations(tId),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTvRecommendations(tId);
        // assert
        verify(mockRemoteDataSource.getTvRecommendations(tId));
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Search Tvs', () {
    final tQuery = 'spiderman';

    test(
      'should return tv list when call to data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchTvs(tQuery),
        ).thenAnswer((_) async => tTvModelList);
        // act
        final result = await repository.searchTvs(tQuery);
        // assert
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchTvs(tQuery),
        ).thenThrow(ServerException());
        // act
        final result = await repository.searchTvs(tQuery);
        // assert
        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchTvs(tQuery),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.searchTvs(tQuery);
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });
}
