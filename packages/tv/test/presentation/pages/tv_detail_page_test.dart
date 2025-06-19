import 'package:core/common/state_enum.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';
import 'package:tv/presentation/provider/tv_detail_notifier.dart';
import 'package:watchlist/presentation/provider/watchlist_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTvDetailNotifier mockTvDetailNotifier;
  late MockWatchlistNotifier mockWatchlistNotifier;

  setUp(() {
    mockTvDetailNotifier = MockTvDetailNotifier();
    mockWatchlistNotifier = MockWatchlistNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TvDetailNotifier>.value(
          value: mockTvDetailNotifier,
        ),
        ChangeNotifierProvider<WatchlistNotifier>.value(
          value: mockWatchlistNotifier,
        ),
      ],
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
    'Watchlist button should display add icon when tv not added to watchlist',
    (WidgetTester tester) async {
      // Arrange: Atur state awal notifier
      when(mockTvDetailNotifier.tvState).thenReturn(RequestState.Loaded);
      when(mockTvDetailNotifier.tv).thenReturn(testTvDetail);
      when(mockTvDetailNotifier.tvRecommendations).thenReturn(<Tv>[]);
      when(
        mockTvDetailNotifier.recommendationState,
      ).thenReturn(RequestState.Loaded);
      when(mockWatchlistNotifier.isAddedToWatchlist).thenReturn(false);

      // Act: Render widget
      final watchlistButtonIcon = find.byIcon(Icons.add);
      await tester.pumpWidget(makeTestableWidget(TvDetailPage(id: 1)));

      // Assert: Pastikan ikon 'add' ditemukan
      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when tv is added to watchlist',
    (WidgetTester tester) async {
      // Arrange
      when(mockTvDetailNotifier.tvState).thenReturn(RequestState.Loaded);
      when(mockTvDetailNotifier.tv).thenReturn(testTvDetail);
      when(mockTvDetailNotifier.tvRecommendations).thenReturn(<Tv>[]);
      when(
        mockTvDetailNotifier.recommendationState,
      ).thenReturn(RequestState.Loaded);
      when(mockWatchlistNotifier.isAddedToWatchlist).thenReturn(true);

      // Act
      final watchlistButtonIcon = find.byIcon(Icons.check);
      await tester.pumpWidget(makeTestableWidget(TvDetailPage(id: 1)));

      // Assert
      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets('should show snackbar when add to watchlist success', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockTvDetailNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockTvDetailNotifier.tv).thenReturn(testTvDetail);
    when(mockTvDetailNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(
      mockTvDetailNotifier.recommendationState,
    ).thenReturn(RequestState.Loaded);
    when(mockWatchlistNotifier.isAddedToWatchlist).thenReturn(false);
    when(
      mockWatchlistNotifier.watchlistMessage,
    ).thenReturn('Added to Watchlist');

    // Act
    await tester.pumpWidget(makeTestableWidget(TvDetailPage(id: 1)));

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

  testWidgets('should show alert dialog when add to watchlist failed', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockTvDetailNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockTvDetailNotifier.tv).thenReturn(testTvDetail);
    when(mockTvDetailNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(
      mockTvDetailNotifier.recommendationState,
    ).thenReturn(RequestState.Loaded);
    when(mockWatchlistNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockWatchlistNotifier.watchlistMessage).thenReturn('Failed');

    // Act
    await tester.pumpWidget(makeTestableWidget(TvDetailPage(id: 1)));

    final watchlistButton = find.byType(FilledButton);
    expect(watchlistButton, findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    // Assert
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets('Page should display CircularProgressIndicator when loading', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockTvDetailNotifier.tvState).thenReturn(RequestState.Loading);

    // Act
    await tester.pumpWidget(makeTestableWidget(TvDetailPage(id: 1)));

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display error message when data failed to load', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockTvDetailNotifier.tvState).thenReturn(RequestState.Error);
    when(mockTvDetailNotifier.message).thenReturn('Failed to load data');

    // Act
    await tester.pumpWidget(makeTestableWidget(TvDetailPage(id: 1)));

    // Assert
    expect(find.text('Failed to load data'), findsOneWidget);
  });
}
