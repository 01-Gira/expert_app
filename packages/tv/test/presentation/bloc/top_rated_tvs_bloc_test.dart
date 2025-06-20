import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/bloc/top_rated_tvs/top_rated_tvs_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TopRatedTvsBloc topRatedTvsBloc;
  late MockGetTopRatedTvs mockGetTopRatedTvs;

  setUp(() {
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    topRatedTvsBloc = TopRatedTvsBloc(mockGetTopRatedTvs);
  });

  test('initial state should be empty', () {
    expect(topRatedTvsBloc.state, TopRatedTvsEmpty());
  });

  blocTest<TopRatedTvsBloc, TopRatedTvsState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      // Arrange
      when(
        mockGetTopRatedTvs.execute(),
      ).thenAnswer((_) async => Right(testTvList));
      return topRatedTvsBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTvs()),
    expect: () => [TopRatedTvsLoading(), TopRatedTvsLoaded(testTvList)],
    verify: (bloc) {
      verify(mockGetTopRatedTvs.execute());
    },
  );

  blocTest<TopRatedTvsBloc, TopRatedTvsState>(
    'Should emit [Loading, Error] when get top rated tvs is unsuccessful',
    build: () {
      // Arrange
      when(
        mockGetTopRatedTvs.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedTvsBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTvs()),
    expect: () => [
      TopRatedTvsLoading(),
      const TopRatedTvsError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTvs.execute());
    },
  );
}
