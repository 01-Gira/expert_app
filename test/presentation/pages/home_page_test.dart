import 'package:expert_app/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/presentation/provider/movie_list_notifier.dart';
import 'package:provider/provider.dart';
import 'package:core/common/state_enum.dart';
import 'package:tv/presentation/provider/tv_list_notifier.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockMovieListNotifier mockMovieListNotifier;
  late MockTvListNotifier mockTvListNotifier;

  setUp(() {
    mockMovieListNotifier = MockMovieListNotifier();
    mockTvListNotifier = MockTvListNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MovieListNotifier>.value(
          value: mockMovieListNotifier,
        ),
        ChangeNotifierProvider<TvListNotifier>.value(value: mockTvListNotifier),
      ],
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
    'Page should display loading indicator when movie states are loading',
    (WidgetTester tester) async {
      when(
        mockMovieListNotifier.nowPlayingState,
      ).thenReturn(RequestState.Loading);
      when(
        mockMovieListNotifier.popularMoviesState,
      ).thenReturn(RequestState.Loading);
      when(
        mockMovieListNotifier.topRatedMoviesState,
      ).thenReturn(RequestState.Loading);
      when(mockTvListNotifier.onTheAirTvsState).thenReturn(RequestState.Empty);
      when(mockTvListNotifier.popularTvsState).thenReturn(RequestState.Empty);
      when(mockTvListNotifier.topRatedTvsState).thenReturn(RequestState.Empty);

      // Act
      final progressFinder = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(_makeTestableWidget(HomePage()));

      expect(progressFinder, findsNWidgets(3));
    },
  );

  testWidgets('Page should display movie lists when data is loaded', (
    WidgetTester tester,
  ) async {
    when(mockMovieListNotifier.nowPlayingState).thenReturn(RequestState.Loaded);
    when(mockMovieListNotifier.nowPlayingMovies).thenReturn(testMovieList);
    when(
      mockMovieListNotifier.popularMoviesState,
    ).thenReturn(RequestState.Loaded);
    when(mockMovieListNotifier.popularMovies).thenReturn(testMovieList);
    when(
      mockMovieListNotifier.topRatedMoviesState,
    ).thenReturn(RequestState.Loaded);
    when(mockMovieListNotifier.topRatedMovies).thenReturn(testMovieList);

    when(mockTvListNotifier.onTheAirTvsState).thenReturn(RequestState.Empty);
    when(mockTvListNotifier.popularTvsState).thenReturn(RequestState.Empty);
    when(mockTvListNotifier.topRatedTvsState).thenReturn(RequestState.Empty);

    // Act
    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(HomePage()));
    // Assert
    expect(listViewFinder, findsNWidgets(3));
  });

  testWidgets('Page should display tv lists when data is loaded on TV tab', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockTvListNotifier.onTheAirTvsState).thenReturn(RequestState.Loaded);
    when(mockTvListNotifier.onTheAirTvs).thenReturn(testTvList);
    when(mockTvListNotifier.popularTvsState).thenReturn(RequestState.Loaded);
    when(mockTvListNotifier.popularTvs).thenReturn(testTvList);
    when(mockTvListNotifier.topRatedTvsState).thenReturn(RequestState.Loaded);
    when(mockTvListNotifier.topRatedTvs).thenReturn(testTvList);

    when(mockMovieListNotifier.nowPlayingState).thenReturn(RequestState.Empty);
    when(
      mockMovieListNotifier.popularMoviesState,
    ).thenReturn(RequestState.Empty);
    when(
      mockMovieListNotifier.topRatedMoviesState,
    ).thenReturn(RequestState.Empty);

    // Act
    await tester.pumpWidget(_makeTestableWidget(HomePage()));

    await tester.tap(find.byIcon(Icons.tv));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    final tvScrollViewFinder = find.byKey(const Key('tv_scroll_view'));
    expect(tvScrollViewFinder, findsOneWidget);

    final listViewFinder = find.descendant(
      of: tvScrollViewFinder,
      matching: find.byType(ListView),
    );

    // Assert
    expect(listViewFinder, findsNWidgets(3));
  });

  testWidgets('Page should display error text when data fetching fails', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockMovieListNotifier.nowPlayingState).thenReturn(RequestState.Error);
    when(mockMovieListNotifier.message).thenReturn('Failed');

    when(
      mockMovieListNotifier.popularMoviesState,
    ).thenReturn(RequestState.Empty);
    when(
      mockMovieListNotifier.topRatedMoviesState,
    ).thenReturn(RequestState.Empty);
    when(mockTvListNotifier.onTheAirTvsState).thenReturn(RequestState.Empty);
    when(mockTvListNotifier.popularTvsState).thenReturn(RequestState.Empty);
    when(mockTvListNotifier.topRatedTvsState).thenReturn(RequestState.Empty);

    // Act
    await tester.pumpWidget(_makeTestableWidget(HomePage()));

    // Assert
    expect(find.text('Failed to load now playing movies'), findsOneWidget);
  });
}
