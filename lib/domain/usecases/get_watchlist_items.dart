import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/media.dart';
import 'package:ditonton/domain/repositories/watchlist_repository.dart';

class GetWatchlistItems {
  final WatchlistRepository _repository;

  GetWatchlistItems(this._repository);

  Future<Either<Failure, List<Media>>> execute() {
    return _repository.getWatchlist();
  }
}
