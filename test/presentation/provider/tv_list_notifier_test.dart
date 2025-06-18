import 'package:dartz/dartz.dart';
import 'package:expert_app/common/failure.dart';
import 'package:expert_app/common/state_enum.dart';
import 'package:expert_app/domain/entities/tv.dart';
import 'package:expert_app/presentation/provider/tv_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvListNotifier provider;
  late MockGetOnTheAirTvs mockGetOnTheAirTvs;
  late MockGetPopularTvs mockGetPopularTvs;
  late MockGetTopRatedTvs mockGetTopRatedTvs;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetOnTheAirTvs = MockGetOnTheAirTvs();
    mockGetPopularTvs = MockGetPopularTvs();
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    provider =
        TvListNotifier(
          getOnTheAirTvs: mockGetOnTheAirTvs,
          getPopularTvs: mockGetPopularTvs,
          getTopRatedTvs: mockGetTopRatedTvs,
        )..addListener(() {
          listenerCallCount += 1;
        });
  });

  final tTv = Tv(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    firstAirDate: 'firstAirDate',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
  );
  final tTvList = <Tv>[tTv];

  group('on the air tvs', () {
    test('initialState should be Empty', () {
      expect(provider.onTheAirTvsState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(
        mockGetOnTheAirTvs.execute(),
      ).thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchOnTheAirTvs();
      // assert
      verify(mockGetOnTheAirTvs.execute());
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(
        mockGetOnTheAirTvs.execute(),
      ).thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchOnTheAirTvs();
      // assert
      expect(provider.onTheAirTvsState, RequestState.Loading);
    });

    test('should change tvs when data is gotten successfully', () async {
      // arrange
      when(
        mockGetOnTheAirTvs.execute(),
      ).thenAnswer((_) async => Right(tTvList));
      // act
      await provider.fetchOnTheAirTvs();
      // assert
      expect(provider.onTheAirTvsState, RequestState.Loaded);
      expect(provider.onTheAirTvs, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockGetOnTheAirTvs.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchOnTheAirTvs();
      // assert
      expect(provider.onTheAirTvsState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular tvs', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetPopularTvs.execute()).thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchPopularTvs();
      // assert
      expect(provider.popularTvsState, RequestState.Loading);
    });

    test('should change tvs data when data is gotten successfully', () async {
      // arrange
      when(mockGetPopularTvs.execute()).thenAnswer((_) async => Right(tTvList));
      // act
      await provider.fetchPopularTvs();
      // assert
      expect(provider.popularTvsState, RequestState.Loaded);
      expect(provider.popularTvs, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockGetPopularTvs.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopularTvs();
      // assert
      expect(provider.popularTvsState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated tvs', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(
        mockGetTopRatedTvs.execute(),
      ).thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchTopRatedTvs();
      // assert
      expect(provider.topRatedTvsState, RequestState.Loading);
    });

    test('should change tvs data when data is gotten successfully', () async {
      // arrange
      when(
        mockGetTopRatedTvs.execute(),
      ).thenAnswer((_) async => Right(tTvList));
      // act
      await provider.fetchTopRatedTvs();
      // assert
      expect(provider.topRatedTvsState, RequestState.Loaded);
      expect(provider.topRatedTvs, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockGetTopRatedTvs.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRatedTvs();
      // assert
      expect(provider.topRatedTvsState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
