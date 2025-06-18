import 'package:dartz/dartz.dart';
import 'package:expert_app/domain/entities/media.dart';
import 'package:expert_app/domain/usecases/search_multi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchMulti usecase;
  late MockSearchRepository mockSearchRepository;

  setUp(() {
    mockSearchRepository = MockSearchRepository();
    usecase = SearchMulti(mockSearchRepository);
  });

  final tMedias = <Media>[];
  final tQuery = 'Spiderman';

  test('should get list of media from the repository', () async {
    // arrange
    when(
      mockSearchRepository.searchMulti(tQuery),
    ).thenAnswer((_) async => Right(tMedias));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, Right(tMedias));
  });
}
