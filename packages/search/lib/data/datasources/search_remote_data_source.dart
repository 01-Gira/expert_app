import 'dart:convert';
import 'package:core/common/exception.dart';
import 'package:search/data/models/media_model.dart';
import 'package:search/data/models/media_response.dart';
import 'package:http/http.dart' as http;
import 'package:core/common/api_config.dart';

abstract class SearchRemoteDataSource {
  Future<List<MediaModel>> searchMulti(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final http.Client client;

  SearchRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MediaModel>> searchMulti(String query) async {
    final response = await client.get(
      Uri.parse('$baseUrl/search/multi?$apiKey&query=$query'),
    );

    if (response.statusCode == 200) {
      return MediaResponse.fromJson(json.decode(response.body)).mediaList;
    } else {
      throw ServerException();
    }
  }
}
