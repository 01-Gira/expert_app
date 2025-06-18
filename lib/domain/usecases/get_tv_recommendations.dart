import 'package:dartz/dartz.dart';
import 'package:expert_app/domain/entities/tv.dart';
import 'package:expert_app/common/failure.dart';
import 'package:expert_app/domain/repositories/tv_repository.dart';

class GetTvRecommendations {
  final TvRepository repository;

  GetTvRecommendations(this.repository);

  Future<Either<Failure, List<Tv>>> execute(id) {
    return repository.getTvRecommendations(id);
  }
}
