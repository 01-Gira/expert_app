import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:search/domain/entities/media.dart';
import 'package:watchlist/domain/repositories/watchlist_repository.dart';

class GetWatchlistItems {
  final WatchlistRepository _repository;

  GetWatchlistItems(this._repository);

  Future<Either<Failure, List<Media>>> execute() {
    return _repository.getWatchlist();
  }
}
