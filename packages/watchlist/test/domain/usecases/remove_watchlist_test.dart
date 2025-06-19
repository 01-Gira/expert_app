import 'package:dartz/dartz.dart';
import 'package:watchlist/domain/usecases/remove_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlistItem usecase;
  late MockWatchlistRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockWatchlistRepository();
    usecase = RemoveWatchlistItem(mockMovieRepository);
  });

  test('should remove watchlist movie from repository', () async {
    // arrange
    when(
      mockMovieRepository.removeWatchlist(1, 'tv'),
    ).thenAnswer((_) async => Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(1, 'tv');
    // assert
    verify(mockMovieRepository.removeWatchlist(1, 'tv'));
    expect(result, Right('Removed from watchlist'));
  });
}
