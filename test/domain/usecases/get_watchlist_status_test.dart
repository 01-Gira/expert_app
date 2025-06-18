import 'package:expert_app/domain/usecases/get_watchlist_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistStatus usecase;
  late MockWatchlistRepository mockWatchlistRepository;

  setUp(() {
    mockWatchlistRepository = MockWatchlistRepository();
    usecase = GetWatchlistStatus(mockWatchlistRepository);
  });

  test('should get watchlist status from repository', () async {
    // arrange
    when(
      mockWatchlistRepository.isAddedToWatchlist(1, 'tv'),
    ).thenAnswer((_) async => true);
    // act
    final result = await usecase.execute(1, 'tv');
    // assert
    expect(result, true);
  });
}
