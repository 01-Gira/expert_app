import 'package:dartz/dartz.dart';
import 'package:expert_app/common/failure.dart';
import 'package:expert_app/domain/entities/media.dart';
import 'package:expert_app/domain/repositories/search_repository.dart';

class SearchMulti {
  final SearchRepository repository;

  SearchMulti(this.repository);

  Future<Either<Failure, List<Media>>> execute(String query) {
    return repository.searchMulti(query);
  }
}
