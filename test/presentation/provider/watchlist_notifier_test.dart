import 'package:dartz/dartz.dart';
import 'package:expert_app/common/failure.dart';
import 'package:expert_app/common/state_enum.dart';
import 'package:expert_app/presentation/provider/watchlist_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late WatchlistNotifier provider;
  late MockGetWatchlistItems mockGetWatchlistItems;
  late MockGetWatchlistStatus mockGetWatchlistStatus;
  late MockSaveWatchlistItem mockSaveWatchlistItem;
  late MockRemoveWatchlistItem mockRemoveWatchlistItem;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetWatchlistItems = MockGetWatchlistItems();
    mockGetWatchlistStatus = MockGetWatchlistStatus();
    mockSaveWatchlistItem = MockSaveWatchlistItem();
    mockRemoveWatchlistItem = MockRemoveWatchlistItem();
    provider =
        WatchlistNotifier(
          getWatchlistItems: mockGetWatchlistItems,
          getWatchListStatus: mockGetWatchlistStatus,
          saveWatchlist: mockSaveWatchlistItem,
          removeWatchlist: mockRemoveWatchlistItem,
        )..addListener(() {
          listenerCallCount += 1;
        });
  });

  group('fetch watchlist items', () {
    test('should change state to loading when usecase is called', () {
      // arrange
      when(
        mockGetWatchlistItems.execute(),
      ).thenAnswer((_) async => Right(testWatchlistItems));
      // act
      provider.fetchWatchlistItems();
      // assert
      expect(provider.watchlistState, RequestState.Loading);
    });

    test(
      'should change watchlist item data when data is gotten successfully',
      () async {
        // arrange
        when(
          mockGetWatchlistItems.execute(),
        ).thenAnswer((_) async => Right([testWatchlistItem]));
        // act
        await provider.fetchWatchlistItems();
        // assert
        expect(provider.watchlistState, RequestState.Loaded);
        expect(provider.watchlistItems, testWatchlistItems);
        expect(listenerCallCount, 2);
      },
    );

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockGetWatchlistItems.execute(),
      ).thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
      // act
      await provider.fetchWatchlistItems();
      // assert
      expect(provider.watchlistState, RequestState.Error);
      expect(provider.message, "Can't get data");
      expect(listenerCallCount, 2);
    });
  });

  group('watchlist status', () {
    test('should get a boolean status whether data is in watchlist', () async {
      // arrange
      when(
        mockGetWatchlistStatus.execute(1, 'movie'),
      ).thenAnswer((_) async => true);
      // act
      await provider.loadWatchlistStatus(1, 'movie');
      // assert
      expect(provider.isAddedToWatchlist, true);
    });
  });

  group('add watchlist', () {
    test('should get success message when adding watchlist', () async {
      // arrange
      when(
        mockSaveWatchlistItem.execute(testWatchlistItem),
      ).thenAnswer((_) async => Right('Added to Watchlist'));
      when(
        mockGetWatchlistStatus.execute(
          testWatchlistItem.id,
          testWatchlistItem.mediaType,
        ),
      ).thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(testWatchlistItem);
      // assert
      expect(provider.watchlistMessage, 'Added to Watchlist');
    });

    test('should get failure message when failed to add watchlist', () async {
      // arrange
      when(
        mockSaveWatchlistItem.execute(testWatchlistItem),
      ).thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(
        mockGetWatchlistStatus.execute(testMovieDetail.id, 'movie'),
      ).thenAnswer((_) async => false);
      // act
      await provider.addWatchlist(testWatchlistItem);
      // assert
      expect(provider.watchlistMessage, 'Failed');
    });
  });

  group('remove watchlist', () {
    test('should get success message when removing watchlist', () async {
      // arrange
      when(
        mockRemoveWatchlistItem.execute(testMovieDetail.id, 'movie'),
      ).thenAnswer((_) async => Right('Removed from Watchlist'));
      when(
        mockGetWatchlistStatus.execute(testMovieDetail.id, 'movie'),
      ).thenAnswer((_) async => false);
      // act
      await provider.removeFromWatchlist(testMovieDetail.id, 'movie');
      // assert
      expect(provider.watchlistMessage, 'Removed from Watchlist');
    });

    test(
      'should get failure message when failed to remove watchlist',
      () async {
        // arrange
        when(
          mockRemoveWatchlistItem.execute(testMovieDetail.id, 'movie'),
        ).thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(
          mockGetWatchlistStatus.execute(testMovieDetail.id, 'movie'),
        ).thenAnswer((_) async => true);
        // act
        await provider.removeFromWatchlist(testMovieDetail.id, 'movie');
        // assert
        expect(provider.watchlistMessage, 'Failed');
      },
    );
  });
}
