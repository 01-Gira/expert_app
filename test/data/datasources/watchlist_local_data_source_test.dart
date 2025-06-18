import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/watchlist_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late WatchlistLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource =
        WatchlistLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save watchlist', () {
    test('should return success message when insert to database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.insertWatchlist(testWatchlistTable.toJson()))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSource.insertWatchlist(testWatchlistTable);
      // assert
      expect(result, 'Added to Watchlist');
    });

    test('should throw DatabaseException when insert to database is failed',
        () async {
      // arrange
      when(mockDatabaseHelper.insertWatchlist(testWatchlistTable.toJson()))
          .thenThrow(Exception());
      // act
      final call = dataSource.insertWatchlist(testWatchlistTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove from database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.removeWatchlist(
              testWatchlistTable.id, testWatchlistTable.mediaType))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSource.removeWatchlist(
          testWatchlistTable.id, testWatchlistTable.mediaType);
      // assert
      expect(result, 'Removed from Watchlist');
    });

    test('should throw DatabaseException when remove from database is failed',
        () async {
      // arrange
      when(mockDatabaseHelper.removeWatchlist(
              testWatchlistTable.id, testWatchlistTable.mediaType))
          .thenThrow(Exception());
      // act
      final call = dataSource.removeWatchlist(
          testWatchlistTable.id, testWatchlistTable.mediaType);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('Get Watchlist by Id', () {
    final tId = 1;
    final tMediaType = 'movie';

    test('should return WatchlistTable when data is found', () async {
      // arrange
      when(mockDatabaseHelper.getItemById(tId, tMediaType))
          .thenAnswer((_) async => testWatchlistMap);
      // act
      final result = await dataSource.getItemById(tId, tMediaType);
      // assert
      expect(result, testWatchlistTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelper.getItemById(tId, tMediaType))
          .thenAnswer((_) async => null);
      // act
      final result = await dataSource.getItemById(tId, tMediaType);
      // assert
      expect(result, null);
    });
  });

  group('get watchlist items', () {
    test('should return list of WatchlistTable from database', () async {
      // arrange
      when(mockDatabaseHelper.getWatchlist())
          .thenAnswer((_) async => [testWatchlistMap]);
      // act
      final result = await dataSource.getWatchlist();
      // assert
      expect(result, [testWatchlistTable]);
    });
  });
}
