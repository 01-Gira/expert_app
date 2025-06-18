import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/repositories/watchlist_repository.dart';

class RemoveWatchlistItem {
  final WatchlistRepository repository;

  RemoveWatchlistItem(this.repository);

  Future<Either<Failure, String>> execute(int id, String mediaType) {
    return repository.removeWatchlist(id, mediaType);
  }
}
