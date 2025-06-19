import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:search/domain/entities/media.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<Media>>> searchMulti(String query);
}
