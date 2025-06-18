import 'package:dartz/dartz.dart';
import 'package:expert_app/common/failure.dart';
import 'package:expert_app/domain/repositories/watchlist_repository.dart';

class RemoveWatchlistItem {
  final WatchlistRepository repository;

  RemoveWatchlistItem(this.repository);

  Future<Either<Failure, String>> execute(int id, String mediaType) {
    return repository.removeWatchlist(id, mediaType);
  }
}
