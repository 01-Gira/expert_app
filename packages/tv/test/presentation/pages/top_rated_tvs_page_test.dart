import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/bloc/top_rated_tvs/top_rated_tvs_bloc.dart';
import 'package:tv/presentation/pages/top_rated_tvs_page.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTopRatedTvsBloc mockTopRatedTvsBloc;

  setUp(() {
    mockTopRatedTvsBloc = MockTopRatedTvsBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvsBloc>.value(
      value: mockTopRatedTvsBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockTopRatedTvsBloc.state).thenReturn(TopRatedTvsLoading());
    when(mockTopRatedTvsBloc.stream).thenAnswer((_) => Stream.empty());

    // Act
    await tester.pumpWidget(makeTestableWidget(const TopRatedTvsPage()));

    // Assert
    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockTopRatedTvsBloc.state).thenReturn(TopRatedTvsLoaded(testTvList));
    when(mockTopRatedTvsBloc.stream).thenAnswer((_) => Stream.empty());
    // Act
    await tester.pumpWidget(makeTestableWidget(const TopRatedTvsPage()));

    // Assert
    final listViewFinder = find.byType(ListView);
    final tvCardFinder = find.byType(TvCard);

    expect(listViewFinder, findsOneWidget);
    expect(tvCardFinder, findsWidgets);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(
      mockTopRatedTvsBloc.state,
    ).thenReturn(const TopRatedTvsError('Error message'));
    when(mockTopRatedTvsBloc.stream).thenAnswer((_) => Stream.empty());

    // Act
    await tester.pumpWidget(makeTestableWidget(const TopRatedTvsPage()));

    // Assert
    final textFinder = find.byKey(const Key('error_message'));
    expect(textFinder, findsOneWidget);
  });
}
