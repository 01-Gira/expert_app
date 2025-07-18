import 'package:dartz/dartz.dart';
import 'package:movie/domain/repositories/movie_repository.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:core/common/failure.dart';

class GetPopularMovies {
  final MovieRepository repository;

  GetPopularMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getPopularMovies();
  }
}
