import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockMovieDetailNotifier mockMovieDetailNotifier;
  late MockWatchlistNotifier mockWatchlistNotifier;

  setUp(() {
    mockMovieDetailNotifier = MockMovieDetailNotifier();
    mockWatchlistNotifier = MockWatchlistNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MovieDetailNotifier>.value(
          value: mockMovieDetailNotifier,
        ),
        ChangeNotifierProvider<WatchlistNotifier>.value(
          value: mockWatchlistNotifier,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    // Arrange: Atur state awal notifier
    when(mockMovieDetailNotifier.movieState).thenReturn(RequestState.Loaded);
    when(mockMovieDetailNotifier.movie).thenReturn(testMovieDetail);
    when(mockMovieDetailNotifier.movieRecommendations).thenReturn(<Movie>[]);
    when(mockMovieDetailNotifier.recommendationState)
        .thenReturn(RequestState.Loaded);
    when(mockWatchlistNotifier.isAddedToWatchlist).thenReturn(false);

    // Act: Render widget
    final watchlistButtonIcon = find.byIcon(Icons.add);
    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    // Assert: Pastikan ikon 'add' ditemukan
    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie is added to watchlist',
      (WidgetTester tester) async {
    // Arrange
    when(mockMovieDetailNotifier.movieState).thenReturn(RequestState.Loaded);
    when(mockMovieDetailNotifier.movie).thenReturn(testMovieDetail);
    when(mockMovieDetailNotifier.movieRecommendations).thenReturn(<Movie>[]);
    when(mockMovieDetailNotifier.recommendationState)
        .thenReturn(RequestState.Loaded);
    when(mockWatchlistNotifier.isAddedToWatchlist).thenReturn(true);

    // Act
    final watchlistButtonIcon = find.byIcon(Icons.check);
    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    // Assert
    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets('should show snackbar when add to watchlist success',
      (WidgetTester tester) async {
    // Arrange
    when(mockMovieDetailNotifier.movieState).thenReturn(RequestState.Loaded);
    when(mockMovieDetailNotifier.movie).thenReturn(testMovieDetail);
    when(mockMovieDetailNotifier.movieRecommendations).thenReturn(<Movie>[]);
    when(mockMovieDetailNotifier.recommendationState)
        .thenReturn(RequestState.Loaded);
    when(mockWatchlistNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockWatchlistNotifier.watchlistMessage)
        .thenReturn('Added to Watchlist');

    // Act
    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    // Temukan tombol watchlist
    final watchlistButton = find.byType(FilledButton);
    expect(watchlistButton, findsOneWidget);

    // Tekan tombolnya
    await tester.tap(watchlistButton);
    await tester.pump(); // Menunggu frame berikutnya setelah state berubah

    // Assert: Verifikasi snackbar muncul
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
    'should show alert dialog when add to watchlist failed',
    (WidgetTester tester) async {
      // Arrange
      when(mockMovieDetailNotifier.movieState).thenReturn(RequestState.Loaded);
      when(mockMovieDetailNotifier.movie).thenReturn(testMovieDetail);
      when(mockMovieDetailNotifier.movieRecommendations).thenReturn(<Movie>[]);
      when(mockMovieDetailNotifier.recommendationState)
          .thenReturn(RequestState.Loaded);
      when(mockWatchlistNotifier.isAddedToWatchlist).thenReturn(false);
      when(mockWatchlistNotifier.watchlistMessage).thenReturn('Failed');

      // Act
      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

      final watchlistButton = find.byType(FilledButton);
      expect(watchlistButton, findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();

      // Assert
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    },
  );

  testWidgets('Page should display CircularProgressIndicator when loading',
      (WidgetTester tester) async {
    // Arrange
    when(mockMovieDetailNotifier.movieState).thenReturn(RequestState.Loading);

    // Act
    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display error message when data failed to load',
      (WidgetTester tester) async {
    // Arrange
    when(mockMovieDetailNotifier.movieState).thenReturn(RequestState.Error);
    when(mockMovieDetailNotifier.message).thenReturn('Failed to load data');

    // Act
    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    // Assert
    expect(find.text('Failed to load data'), findsOneWidget);
  });
}
