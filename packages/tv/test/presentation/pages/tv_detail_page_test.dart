import 'package:core/common/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';
import '../../helpers/test_helper.mocks.dart';
import '../../dummy_data/dummy_objects.dart';

void main() {
  late MockTvDetailBloc mockTvDetailBloc;

  setUp(() {
    mockTvDetailBloc = MockTvDetailBloc();
    when(mockTvDetailBloc.state).thenReturn(const TvDetailState());
    when(mockTvDetailBloc.stream).thenAnswer((_) => Stream.empty());
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvDetailBloc>.value(
      value: mockTvDetailBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
    'Watchlist button should display add icon when tv not added to watchlist',
    (WidgetTester tester) async {
      // Arrange
      when(mockTvDetailBloc.state).thenReturn(
        TvDetailState(
          tvState: RequestState.loaded,
          tv: testTvDetail,
          isAddedToWatchlist: false,
        ),
      );

      // Act
      await tester.pumpWidget(makeTestableWidget(TvDetailPage(id: 1)));

      // Assert
      expect(find.byIcon(Icons.add), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when tv is added to watchlist',
    (WidgetTester tester) async {
      // Arrange
      when(mockTvDetailBloc.state).thenReturn(
        TvDetailState(
          tvState: RequestState.loaded,
          tv: testTvDetail,
          isAddedToWatchlist: true,
        ),
      );

      // Act
      await tester.pumpWidget(makeTestableWidget(TvDetailPage(id: 1)));

      // Assert
      expect(find.byIcon(Icons.check), findsOneWidget);
    },
  );

  testWidgets('should show snackbar when add to watchlist success', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockTvDetailBloc.state).thenReturn(
      const TvDetailState(
        tvState: RequestState.loaded,
        tv: testTvDetail,
        isAddedToWatchlist: false,
      ),
    );
    final successState = TvDetailState(
      tvState: RequestState.loaded,
      tv: testTvDetail,
      isAddedToWatchlist: true,
      watchlistMessage: TvDetailBloc.watchlistAddSuccessMessage,
    );
    when(mockTvDetailBloc.stream).thenAnswer((_) => Stream.value(successState));

    // Act
    await tester.pumpWidget(makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    // Assert
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);

    await tester.pump();
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('should display loading indicator when state is loading', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(
      mockTvDetailBloc.state,
    ).thenReturn(const TvDetailState(tvState: RequestState.loading));

    // Act
    await tester.pumpWidget(makeTestableWidget(TvDetailPage(id: 1)));

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display error message when data failed to load', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockTvDetailBloc.state).thenReturn(
      const TvDetailState(
        tvState: RequestState.error,
        message: 'Failed to load data',
      ),
    );

    // Act
    await tester.pumpWidget(makeTestableWidget(TvDetailPage(id: 1)));

    // Assert
    expect(find.text('Failed to load data'), findsOneWidget);
  });
}
