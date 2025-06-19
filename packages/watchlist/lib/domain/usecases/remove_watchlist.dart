import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:watchlist/domain/repositories/watchlist_repository.dart';

class RemoveWatchlistItem {
  final WatchlistRepository repository;

  RemoveWatchlistItem(this.repository);

  Future<Either<Failure, String>> execute(int id, String mediaType) {
    return repository.removeWatchlist(id, mediaType);
  }
}
