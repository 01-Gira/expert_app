import 'package:dartz/dartz.dart';
import 'package:expert_app/common/failure.dart';
import 'package:expert_app/domain/entities/movie.dart';
import 'package:expert_app/domain/repositories/movie_repository.dart';

class GetPopularMovies {
  final MovieRepository repository;

  GetPopularMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getPopularMovies();
  }
}
