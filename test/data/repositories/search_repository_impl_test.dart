import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/media_model.dart';
import 'package:ditonton/data/repositories/search_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchRepositoryImpl repository;
  late MockSearchRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockSearchRemoteDataSource();
    repository = SearchRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group('Search Multi', () {
    final tQuery = 'spiderman';
    final tMediaModelList = <MediaModel>[
      MediaModel(
        id: 1,
        title: 'Spider-Man',
        posterPath: '/path.jpg',
        overview: 'overview',
        mediaType: 'movie',
      ),
    ];
    final tMediaList =
        tMediaModelList.map((model) => model.toEntity()).toList();

    test('should return media list when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchMulti(tQuery))
          .thenAnswer((_) async => tMediaModelList);
      // act
      final result = await repository.searchMulti(tQuery);
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, tMediaList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchMulti(tQuery))
          .thenThrow(ServerException());
      // act
      final result = await repository.searchMulti(tQuery);
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.searchMulti(tQuery))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.searchMulti(tQuery);
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });
}
