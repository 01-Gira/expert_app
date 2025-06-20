import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:search/domain/entities/media.dart';
import 'package:search/presentation/bloc/search/search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchBloc searchBloc;
  late MockSearchMulti mockSearchMulti;

  setUp(() {
    mockSearchMulti = MockSearchMulti();
    searchBloc = SearchBloc(mockSearchMulti);
  });

  final tMediaModel = Media(
    id: 1,
    title: 'Test Movie',
    posterPath: '/path.jpg',
    overview: 'Test Overview',
    mediaType: 'movie',
  );
  final tMediaList = <Media>[tMediaModel];
  final tQuery = 'spiderman';

  test('initial state should be empty', () {
    expect(searchBloc.state, SearchEmpty());
  });

  blocTest<SearchBloc, SearchState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      // Arrange
      when(
        mockSearchMulti.execute(tQuery),
      ).thenAnswer((_) async => Right(tMediaList));
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    // Menunggu debounce time
    wait: const Duration(milliseconds: 500),
    expect: () => [SearchLoading(), SearchLoaded(tMediaList)],
    verify: (bloc) {
      verify(mockSearchMulti.execute(tQuery));
    },
  );

  blocTest<SearchBloc, SearchState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      // Arrange
      when(
        mockSearchMulti.execute(tQuery),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    // Menunggu debounce time
    wait: const Duration(milliseconds: 500),
    expect: () => [SearchLoading(), SearchError('Server Failure')],
    verify: (bloc) {
      verify(mockSearchMulti.execute(tQuery));
    },
  );

  blocTest<SearchBloc, SearchState>(
    'Should emit [Loading, Empty] when data is empty',
    build: () {
      // Arrange
      when(
        mockSearchMulti.execute(tQuery),
      ).thenAnswer((_) async => Right(<Media>[])); // Mengembalikan list kosong
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchLoading(),
      SearchLoaded(<Media>[]), // Harusnya emit state loaded dengan data kosong
    ],
    verify: (bloc) {
      verify(mockSearchMulti.execute(tQuery));
    },
  );
}
