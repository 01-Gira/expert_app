import 'package:dartz/dartz.dart';
import 'package:expert_app/common/failure.dart';
import 'package:expert_app/domain/entities/media.dart';
import 'package:expert_app/domain/repositories/watchlist_repository.dart';

class GetWatchlistItems {
  final WatchlistRepository _repository;

  GetWatchlistItems(this._repository);

  Future<Either<Failure, List<Media>>> execute() {
    return _repository.getWatchlist();
  }
}
