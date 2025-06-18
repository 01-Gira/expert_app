import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/media.dart';
import 'package:ditonton/domain/repositories/search_repository.dart';

class SearchMulti {
  final SearchRepository repository;

  SearchMulti(this.repository);

  Future<Either<Failure, List<Media>>> execute(String query) {
    return repository.searchMulti(query);
  }
}
