import 'dart:convert';

import 'package:expert_app/data/datasources/search_remote_data_source.dart';
import 'package:expert_app/common/exception.dart';
import 'package:expert_app/data/models/media_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late SearchRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = SearchRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get On The Search Multis', () {
    final tTvList = MediaResponse.fromJson(
      json.decode(readJson('dummy_data/search_game_of_thrones.json')),
    ).mediaList;
    final q = 'game of thrones';
    test(
      'should return list of Media Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$BASE_URL/search/multi?$API_KEY&query=$q'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/search_game_of_thrones.json'),
            200,
          ),
        );
        // act
        final result = await dataSource.searchMulti(q);

        expect(result, equals(tTvList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        when(
          mockHttpClient.get(
            Uri.parse('$BASE_URL/search/multi?$API_KEY&query=$q'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        // act
        final call = dataSource.searchMulti(q);

        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });
}
