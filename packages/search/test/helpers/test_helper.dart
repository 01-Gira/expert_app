import 'package:flutter/material.dart';
import 'package:search/data/datasources/search_remote_data_source.dart';
import 'package:search/domain/repositories/search_repository.dart';
import 'package:search/domain/usecases/search_multi.dart';
import 'package:search/presentation/bloc/search/search_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks(
  [
    SearchRepository,
    SearchRemoteDataSource,
    SearchMulti,
    SearchBloc,
    NavigatorObserver,
  ],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)
void main() {}
