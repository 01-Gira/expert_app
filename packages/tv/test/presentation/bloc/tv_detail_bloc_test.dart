import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/common/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvDetailBloc tvDetailBloc;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetWatchlistStatus mockGetWatchlistStatus;
  late MockSaveWatchlistItem mockSaveWatchlistItem;
  late MockRemoveWatchlistItem mockRemoveWatchlistItem;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetWatchlistStatus = MockGetWatchlistStatus();
    mockSaveWatchlistItem = MockSaveWatchlistItem();
    mockRemoveWatchlistItem = MockRemoveWatchlistItem();
    tvDetailBloc = TvDetailBloc(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      getWatchlistStatus: mockGetWatchlistStatus,
      saveWatchlistItem: mockSaveWatchlistItem,
      removeWatchlistItem: mockRemoveWatchlistItem,
    );
  });

  const tId = 1;

  test('initial state should be empty', () {
    expect(tvDetailBloc.state, const TvDetailState());
  });

  group('FetchTvDetail', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetTvDetail.execute(tId),
        ).thenAnswer((_) async => Right(testTvDetail));
        when(
          mockGetTvRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(testTvList));
        when(
          mockGetWatchlistStatus.execute(tId, 'tv'),
        ).thenAnswer((_) async => true);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect: () => [
        const TvDetailState(tvState: RequestState.loading),
        TvDetailState(
          tvState: RequestState.loading,
          recommendationState: RequestState.loading,
          tv: testTvDetail,
          isAddedToWatchlist: true,
        ),
        TvDetailState(
          tvState: RequestState.loaded,
          recommendationState: RequestState.loaded,
          tv: testTvDetail,
          tvRecommendations: testTvList,
          isAddedToWatchlist: true,
        ),
      ],
      verify: (_) {
        verify(mockGetTvDetail.execute(tId));
        verify(mockGetTvRecommendations.execute(tId));
        verify(mockGetWatchlistStatus.execute(tId, 'tv'));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should emit [Loading, Error] when get detail is unsuccessful',
      build: () {
        when(
          mockGetTvDetail.execute(tId),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(
          mockGetTvRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(testTvList));
        when(
          mockGetWatchlistStatus.execute(tId, 'tv'),
        ).thenAnswer((_) async => false);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect: () => [
        const TvDetailState(tvState: RequestState.loading),
        const TvDetailState(
          tvState: RequestState.error,
          message: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetTvDetail.execute(tId));
      },
    );
  });

  group('AddToWatchlist', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'should emit watchlist message and status when successful',
      build: () {
        when(
          mockSaveWatchlistItem.execute(testTvDetail.toMedia()),
        ).thenAnswer((_) async => const Right('Added to Watchlist'));
        when(
          mockGetWatchlistStatus.execute(testTvDetail.id, 'tv'),
        ).thenAnswer((_) async => true);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(testTvDetail)),
      expect: () => [
        const TvDetailState(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: false,
        ),
        const TvDetailState(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlistItem.execute(testTvDetail.toMedia()));
        verify(mockGetWatchlistStatus.execute(testTvDetail.id, 'tv'));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should emit failure message when unsuccessful',
      build: () {
        when(
          mockSaveWatchlistItem.execute(testTvDetail.toMedia()),
        ).thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(
          mockGetWatchlistStatus.execute(testTvDetail.id, 'tv'),
        ).thenAnswer((_) async => false);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(testTvDetail)),
      expect: () => [
        const TvDetailState(
          watchlistMessage: 'Failed',
          isAddedToWatchlist: false,
        ),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlistItem.execute(testTvDetail.toMedia()));
        verify(mockGetWatchlistStatus.execute(testTvDetail.id, 'tv'));
      },
    );
  });

  group('RemoveFromWatchlist', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'should emit watchlist message and status when successful',
      build: () {
        when(
          mockRemoveWatchlistItem.execute(testTvDetail.id, 'tv'),
        ).thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(
          mockGetWatchlistStatus.execute(testTvDetail.id, 'tv'),
        ).thenAnswer((_) async => false);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(testTvDetail)),
      expect: () => [
        const TvDetailState(watchlistMessage: 'Removed from Watchlist'),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistItem.execute(testTvDetail.id, 'tv'));
        verify(mockGetWatchlistStatus.execute(testTvDetail.id, 'tv'));
      },
    );
  });
}
