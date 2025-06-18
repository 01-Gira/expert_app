import 'dart:convert';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/media_model.dart';
import 'package:ditonton/data/models/media_response.dart';
import 'package:http/http.dart' as http;

abstract class SearchRemoteDataSource {
  Future<List<MediaModel>> searchMulti(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final http.Client client;

  SearchRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MediaModel>> searchMulti(String query) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/search/multi?$API_KEY&query=$query'));

    if (response.statusCode == 200) {
      return MediaResponse.fromJson(json.decode(response.body)).mediaList;
    } else {
      throw ServerException();
    }
  }
}
