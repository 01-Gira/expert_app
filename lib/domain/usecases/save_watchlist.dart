import 'package:dartz/dartz.dart';
import 'package:expert_app/common/failure.dart';
import 'package:expert_app/domain/entities/media.dart';
import 'package:expert_app/domain/repositories/watchlist_repository.dart';

class SaveWatchlistItem {
  final WatchlistRepository repository;

  SaveWatchlistItem(this.repository);

  Future<Either<Failure, String>> execute(Media item) {
    return repository.saveWatchlist(item);
  }
}
