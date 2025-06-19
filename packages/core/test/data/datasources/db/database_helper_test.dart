import 'package:core/data/datasources/db/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../dummy_data/dummy_objects.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Database Helper', () {
    late DatabaseHelper databaseHelper;

    setUp(() {
      databaseHelper = DatabaseHelper();
    });

    test('should return database when get database is called', () async {
      // Act
      final db = await databaseHelper.database;
      // Assert
      expect(db, isA<Database>());
    });

    group('Watchlist Tests', () {
      setUp(() async {
        final db = await databaseHelper.database;
        await db!.delete('watchlist');
      });

      test('should insert watchlist item to database', () async {
        // Arrange
        // Act
        final result = await databaseHelper.insertWatchlist(testWatchlistMap);
        // Assert
        expect(result, 1);
      });

      test(
        'should get watchlist item by id and mediaType from database',
        () async {
          // Arrange
          await databaseHelper.insertWatchlist(testWatchlistMap);
          // Act
          final result = await databaseHelper.getItemById(1, 'movie');
          // Assert
          expect(result, testWatchlistMap);
        },
      );

      test('should get all watchlist items from database', () async {
        // Arrange
        await databaseHelper.insertWatchlist(testWatchlistMap);
        // Act
        final result = await databaseHelper.getWatchlist();
        // Assert
        expect(result, [testWatchlistMap]);
      });

      test('should remove watchlist item from database', () async {
        // Arrange
        await databaseHelper.insertWatchlist(testWatchlistMap);
        // Act
        await databaseHelper.removeWatchlist(1, 'movie');
        final result = await databaseHelper.getItemById(1, 'movie');
        // Assert
        expect(result, null);
      });
    });
  });
}
