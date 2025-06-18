import 'package:dartz/dartz.dart';
import 'package:expert_app/domain/entities/movie.dart';
import 'package:expert_app/domain/repositories/movie_repository.dart';
import 'package:expert_app/common/failure.dart';

class GetNowPlayingMovies {
  final MovieRepository repository;

  GetNowPlayingMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getNowPlayingMovies();
  }
}
