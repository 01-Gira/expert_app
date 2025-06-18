import 'package:dartz/dartz.dart';
import 'package:expert_app/common/failure.dart';
import 'package:expert_app/domain/entities/media.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<Media>>> searchMulti(String query);
}
