import 'dart:convert';
import 'package:core/common/api_config.dart';
import 'package:search/data/datasources/search_remote_data_source.dart';
import 'package:core/common/exception.dart';
import 'package:search/data/models/media_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
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
            Uri.parse('$baseUrl/search/multi?$apiKey&query=$q'),
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
            Uri.parse('$baseUrl/search/multi?$apiKey&query=$q'),
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
