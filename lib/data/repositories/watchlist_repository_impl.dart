import 'package:dartz/dartz.dart';
import 'package:expert_app/common/exception.dart';
import 'package:expert_app/common/failure.dart';
import 'package:expert_app/data/datasources/watchlist_local_data_source.dart';
import 'package:expert_app/data/models/watchlist_table.dart';
import 'package:expert_app/domain/entities/media.dart';
import 'package:expert_app/domain/repositories/watchlist_repository.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final WatchlistLocalDataSource localDataSource;

  WatchlistRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Media>>> getWatchlist() async {
    final result = await localDataSource.getWatchlist();
    return Right(result.map((data) => data.toEntity()).toList());
  }

  @override
  Future<bool> isAddedToWatchlist(int id, String mediaType) async {
    final result = await localDataSource.getItemById(id, mediaType);
    return result != null;
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(
    int id,
    String mediaType,
  ) async {
    try {
      final result = await localDataSource.removeWatchlist(id, mediaType);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(Media item) async {
    try {
      final watchlistTable = WatchlistTable.fromEntity(item);

      final result = await localDataSource.insertWatchlist(watchlistTable);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      throw e;
    }
  }
}
