import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/models/watchlist_table.dart';

abstract class WatchlistLocalDataSource {
  Future<String> insertWatchlist(WatchlistTable item);
  Future<String> removeWatchlist(int id, String mediaType);
  Future<WatchlistTable?> getItemById(int id, String mediaType);
  Future<List<WatchlistTable>> getWatchlist();
}

class WatchlistLocalDataSourceImpl implements WatchlistLocalDataSource {
  final DatabaseHelper databaseHelper;

  WatchlistLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlist(WatchlistTable item) async {
    try {
      await databaseHelper.insertWatchlist(item.toJson());
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(int id, String mediaType) async {
    try {
      await databaseHelper.removeWatchlist(id, mediaType);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<WatchlistTable?> getItemById(int id, String mediaType) async {
    final result = await databaseHelper.getItemById(id, mediaType);
    if (result != null) {
      return WatchlistTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<WatchlistTable>> getWatchlist() async {
    final result = await databaseHelper.getWatchlist();
    return result.map((data) => WatchlistTable.fromMap(data)).toList();
  }
}
