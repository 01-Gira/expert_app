import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:expert_app/common/exception.dart';
import 'package:expert_app/common/failure.dart';
import 'package:expert_app/data/datasources/search_remote_data_source.dart';
import 'package:expert_app/domain/entities/media.dart';
import 'package:expert_app/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Media>>> searchMulti(String query) async {
    try {
      final result = await remoteDataSource.searchMulti(query);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }
}
