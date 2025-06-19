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

  Widget makeTestableWidget(Widget body) {
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
      ).thenReturn(RequestState.loading);
      when(
        mockMovieListNotifier.popularMoviesState,
      ).thenReturn(RequestState.loading);
      when(
        mockMovieListNotifier.topRatedMoviesState,
      ).thenReturn(RequestState.loading);
      when(mockTvListNotifier.onTheAirTvsState).thenReturn(RequestState.empty);
      when(mockTvListNotifier.popularTvsState).thenReturn(RequestState.empty);
      when(mockTvListNotifier.topRatedTvsState).thenReturn(RequestState.empty);

      // Act
      final progressFinder = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(makeTestableWidget(HomePage()));

      expect(progressFinder, findsNWidgets(3));
    },
  );

  testWidgets('Page should display movie lists when data is loaded', (
    WidgetTester tester,
  ) async {
    when(mockMovieListNotifier.nowPlayingState).thenReturn(RequestState.loaded);
    when(mockMovieListNotifier.nowPlayingMovies).thenReturn(testMovieList);
    when(
      mockMovieListNotifier.popularMoviesState,
    ).thenReturn(RequestState.loaded);
    when(mockMovieListNotifier.popularMovies).thenReturn(testMovieList);
    when(
      mockMovieListNotifier.topRatedMoviesState,
    ).thenReturn(RequestState.loaded);
    when(mockMovieListNotifier.topRatedMovies).thenReturn(testMovieList);

    when(mockTvListNotifier.onTheAirTvsState).thenReturn(RequestState.empty);
    when(mockTvListNotifier.popularTvsState).thenReturn(RequestState.empty);
    when(mockTvListNotifier.topRatedTvsState).thenReturn(RequestState.empty);

    // Act
    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(HomePage()));
    // Assert
    expect(listViewFinder, findsNWidgets(3));
  });

  testWidgets('Page should display tv lists when data is loaded on TV tab', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockTvListNotifier.onTheAirTvsState).thenReturn(RequestState.loaded);
    when(mockTvListNotifier.onTheAirTvs).thenReturn(testTvList);
    when(mockTvListNotifier.popularTvsState).thenReturn(RequestState.loaded);
    when(mockTvListNotifier.popularTvs).thenReturn(testTvList);
    when(mockTvListNotifier.topRatedTvsState).thenReturn(RequestState.loaded);
    when(mockTvListNotifier.topRatedTvs).thenReturn(testTvList);

    when(mockMovieListNotifier.nowPlayingState).thenReturn(RequestState.empty);
    when(
      mockMovieListNotifier.popularMoviesState,
    ).thenReturn(RequestState.empty);
    when(
      mockMovieListNotifier.topRatedMoviesState,
    ).thenReturn(RequestState.empty);

    // Act
    await tester.pumpWidget(makeTestableWidget(HomePage()));

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
    when(mockMovieListNotifier.nowPlayingState).thenReturn(RequestState.error);
    when(mockMovieListNotifier.message).thenReturn('Failed');

    when(
      mockMovieListNotifier.popularMoviesState,
    ).thenReturn(RequestState.empty);
    when(
      mockMovieListNotifier.topRatedMoviesState,
    ).thenReturn(RequestState.empty);
    when(mockTvListNotifier.onTheAirTvsState).thenReturn(RequestState.empty);
    when(mockTvListNotifier.popularTvsState).thenReturn(RequestState.empty);
    when(mockTvListNotifier.topRatedTvsState).thenReturn(RequestState.empty);

    // Act
    await tester.pumpWidget(makeTestableWidget(HomePage()));

    // Assert
    expect(find.text('Failed to load now playing movies'), findsOneWidget);
  });
}
