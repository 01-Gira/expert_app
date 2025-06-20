import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/common/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/bloc/tv_list/tv_list_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvListBloc tvListBloc;
  late MockGetOnTheAirTvs mockGetOnTheAirTvs;
  late MockGetPopularTvs mockGetPopularTvs;
  late MockGetTopRatedTvs mockGetTopRatedTvs;

  setUp(() {
    mockGetOnTheAirTvs = MockGetOnTheAirTvs();
    mockGetPopularTvs = MockGetPopularTvs();
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    tvListBloc = TvListBloc(
      mockGetOnTheAirTvs,
      mockGetPopularTvs,
      mockGetTopRatedTvs,
    );
  });

  test('initial state should be correct', () {
    expect(tvListBloc.state, const TvListState());
  });

  group('FetchOnTheAirTvs event', () {
    blocTest<TvListBloc, TvListState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetOnTheAirTvs.execute(),
        ).thenAnswer((_) async => Right(testTvList));
        return tvListBloc;
      },
      act: (bloc) => bloc.add(FetchOnTheAirTvs()),
      expect: () => [
        const TvListState(onTheAirState: RequestState.loading),
        TvListState(
          onTheAirState: RequestState.loaded,
          onTheAirTvs: testTvList,
        ),
      ],
      verify: (bloc) {
        verify(mockGetOnTheAirTvs.execute());
      },
    );

    blocTest<TvListBloc, TvListState>(
      'Should emit [Loading, Error] when get on the air tvs is unsuccessful',
      build: () {
        when(
          mockGetOnTheAirTvs.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvListBloc;
      },
      act: (bloc) => bloc.add(FetchOnTheAirTvs()),
      expect: () => [
        const TvListState(onTheAirState: RequestState.loading),
        const TvListState(
          onTheAirState: RequestState.error,
          message: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetOnTheAirTvs.execute());
      },
    );
  });

  group('FetchPopularTvs event', () {
    blocTest<TvListBloc, TvListState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetPopularTvs.execute(),
        ).thenAnswer((_) async => Right(testTvList));
        return tvListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvs()),
      expect: () => [
        const TvListState(popularTvsState: RequestState.loading),
        TvListState(
          popularTvsState: RequestState.loaded,
          popularTvs: testTvList,
        ),
      ],
      verify: (bloc) {
        verify(mockGetPopularTvs.execute());
      },
    );

    blocTest<TvListBloc, TvListState>(
      'Should emit [Loading, Error] when get popular tvs is unsuccessful',
      build: () {
        when(
          mockGetPopularTvs.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvs()),
      expect: () => [
        const TvListState(popularTvsState: RequestState.loading),
        const TvListState(
          popularTvsState: RequestState.error,
          message: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetPopularTvs.execute());
      },
    );
  });

  group('FetchTopRatedTvs event', () {
    blocTest<TvListBloc, TvListState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetTopRatedTvs.execute(),
        ).thenAnswer((_) async => Right(testTvList));
        return tvListBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvs()),
      expect: () => [
        const TvListState(topRatedTvsState: RequestState.loading),
        TvListState(
          topRatedTvsState: RequestState.loaded,
          topRatedTvs: testTvList,
        ),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTvs.execute());
      },
    );

    blocTest<TvListBloc, TvListState>(
      'Should emit [Loading, Error] when get top rated tvs is unsuccessful',
      build: () {
        when(
          mockGetTopRatedTvs.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvListBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvs()),
      expect: () => [
        const TvListState(topRatedTvsState: RequestState.loading),
        const TvListState(
          topRatedTvsState: RequestState.error,
          message: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTvs.execute());
      },
    );
  });
}
