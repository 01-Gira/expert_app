import 'package:dartz/dartz.dart';
import 'package:expert_app/domain/entities/movie_detail.dart';
import 'package:expert_app/domain/repositories/movie_repository.dart';
import 'package:expert_app/common/failure.dart';

class GetMovieDetail {
  final MovieRepository repository;

  GetMovieDetail(this.repository);

  Future<Either<Failure, MovieDetail>> execute(int id) {
    return repository.getMovieDetail(id);
  }
}
