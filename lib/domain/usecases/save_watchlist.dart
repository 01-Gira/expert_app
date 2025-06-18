import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/media.dart';
import 'package:ditonton/domain/repositories/watchlist_repository.dart';

class SaveWatchlistItem {
  final WatchlistRepository repository;

  SaveWatchlistItem(this.repository);

  Future<Either<Failure, String>> execute(Media item) {
    return repository.saveWatchlist(item);
  }
}
