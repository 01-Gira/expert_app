import 'package:dartz/dartz.dart';

import 'package:tv/domain/entities/tv.dart';
import 'package:core/common/failure.dart';
import 'package:tv/domain/repositories/tv_repository.dart';

class GetOnTheAirTvs {
  final TvRepository repository;

  GetOnTheAirTvs(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getOnTheAirTvs();
  }
}
