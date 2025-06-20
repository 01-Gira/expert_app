import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/bloc/popular_tvs/popular_tvs_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late PopularTvsBloc popularTvsBloc;
  late MockGetPopularTvs mockGetPopularTvs;

  setUp(() {
    mockGetPopularTvs = MockGetPopularTvs();
    popularTvsBloc = PopularTvsBloc(mockGetPopularTvs);
  });

  test('initial state should be empty', () {
    expect(popularTvsBloc.state, PopularTvsEmpty());
  });

  blocTest<PopularTvsBloc, PopularTvsState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      // Arrange
      when(
        mockGetPopularTvs.execute(),
      ).thenAnswer((_) async => Right(testTvList));
      return popularTvsBloc;
    },
    act: (bloc) => bloc.add(FetchPopularTvs()),
    expect: () => [PopularTvsLoading(), PopularTvsLoaded(testTvList)],
    verify: (bloc) {
      verify(mockGetPopularTvs.execute());
    },
  );

  blocTest<PopularTvsBloc, PopularTvsState>(
    'Should emit [Loading, Error] when get popular tvs is unsuccessful',
    build: () {
      // Arrange
      when(
        mockGetPopularTvs.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularTvsBloc;
    },
    act: (bloc) => bloc.add(FetchPopularTvs()),
    expect: () => [
      PopularTvsLoading(),
      const PopularTvsError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetPopularTvs.execute());
    },
  );
}
