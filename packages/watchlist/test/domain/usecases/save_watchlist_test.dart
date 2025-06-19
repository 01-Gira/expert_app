import 'package:dartz/dartz.dart';
import 'package:watchlist/domain/usecases/save_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlistItem usecase;
  late MockWatchlistRepository mockWatchlistRepository;

  setUp(() {
    mockWatchlistRepository = MockWatchlistRepository();
    usecase = SaveWatchlistItem(mockWatchlistRepository);
  });

  test('should save movie to the repository', () async {
    // arrange
    when(
      mockWatchlistRepository.saveWatchlist(testWatchlistItem),
    ).thenAnswer((_) async => Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testWatchlistItem);
    // assert
    verify(mockWatchlistRepository.saveWatchlist(testWatchlistItem));
    expect(result, Right('Added to Watchlist'));
  });
}
