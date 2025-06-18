import 'package:dartz/dartz.dart';
import 'package:expert_app/domain/entities/movie.dart';
import 'package:expert_app/domain/repositories/movie_repository.dart';
import 'package:expert_app/common/failure.dart';

class GetMovieRecommendations {
  final MovieRepository repository;

  GetMovieRecommendations(this.repository);

  Future<Either<Failure, List<Movie>>> execute(id) {
    return repository.getMovieRecommendations(id);
  }
}
