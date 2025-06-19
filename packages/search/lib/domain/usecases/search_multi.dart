import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:search/domain/entities/media.dart';
import 'package:search/domain/repositories/search_repository.dart';

class SearchMulti {
  final SearchRepository repository;

  SearchMulti(this.repository);

  Future<Either<Failure, List<Media>>> execute(String query) {
    return repository.searchMulti(query);
  }
}
