import 'package:dartz/dartz.dart';
import 'package:expert_app/domain/usecases/get_watchlist_items.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistItems usecase;
  late MockWatchlistRepository mockWatchlistRepository;

  setUp(() {
    mockWatchlistRepository = MockWatchlistRepository();
    usecase = GetWatchlistItems(mockWatchlistRepository);
  });

  test('should get list of watchlist from the repository', () async {
    // arrange
    when(
      mockWatchlistRepository.getWatchlist(),
    ).thenAnswer((_) async => Right(testWatchlistItems));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testWatchlistItems));
  });
}
