import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:search/domain/entities/media.dart';
import 'package:watchlist/domain/repositories/watchlist_repository.dart';

class SaveWatchlistItem {
  final WatchlistRepository repository;

  SaveWatchlistItem(this.repository);

  Future<Either<Failure, String>> execute(Media item) {
    return repository.saveWatchlist(item);
  }
}
