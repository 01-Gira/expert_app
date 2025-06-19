import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:search/domain/entities/media.dart';

abstract class WatchlistRepository {
  Future<Either<Failure, String>> saveWatchlist(Media item);
  Future<Either<Failure, String>> removeWatchlist(int id, String mediaType);
  Future<bool> isAddedToWatchlist(int id, String mediaType);
  Future<Either<Failure, List<Media>>> getWatchlist();
}
