import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/bloc/popular_tvs/popular_tvs_bloc.dart';
import 'package:tv/presentation/pages/popular_tvs_page.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockPopularTvsBloc mockPopularTvsBloc;

  setUp(() {
    mockPopularTvsBloc = MockPopularTvsBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvsBloc>.value(
      value: mockPopularTvsBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockPopularTvsBloc.state).thenReturn(PopularTvsLoading());
    when(mockPopularTvsBloc.stream).thenAnswer((_) => Stream.empty());

    // Act
    await tester.pumpWidget(makeTestableWidget(const PopularTvsPage()));

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
    when(mockPopularTvsBloc.state).thenReturn(PopularTvsLoaded(testTvList));
    when(mockPopularTvsBloc.stream).thenAnswer((_) => Stream.empty());

    // Act
    await tester.pumpWidget(makeTestableWidget(const PopularTvsPage()));

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
      mockPopularTvsBloc.state,
    ).thenReturn(const PopularTvsError('Error message'));
    when(mockPopularTvsBloc.stream).thenAnswer((_) => Stream.empty());

    // Act
    await tester.pumpWidget(makeTestableWidget(const PopularTvsPage()));

    // Assert
    final textFinder = find.byKey(const Key('error_message'));
    expect(textFinder, findsOneWidget);
  });
}
