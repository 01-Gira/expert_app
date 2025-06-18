import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/media.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<Media>>> searchMulti(String query);
}
