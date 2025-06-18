import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/media.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/provider/search_notifier.dart';
import 'package:ditonton/presentation/widgets/media_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockSearchNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockSearchNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<SearchNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(home: body),
    );
  }

  final tMedia = Media(
    id: 1,
    title: 'Test Movie',
    posterPath: '/path.jpg',
    overview: 'Test Overview',
    mediaType: 'movie',
  );
  final tMediaList = <Media>[tMedia];

  testWidgets('should display progress bar when state is loading', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockNotifier.state).thenReturn(RequestState.Loading);

    // Act
    await tester.pumpWidget(_makeTestableWidget(SearchPage()));

    // Assert
    final progressBarFinder = find.byType(CircularProgressIndicator);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('should display MediaCard when data is loaded', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockNotifier.state).thenReturn(RequestState.Loaded);
    when(mockNotifier.searchResult).thenReturn(tMediaList);

    // Act
    await tester.pumpWidget(_makeTestableWidget(SearchPage()));

    // Assert
    final mediaCardFinder = find.byType(MediaCard);
    expect(mediaCardFinder, findsOneWidget);
  });

  testWidgets('should display empty container when Error', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockNotifier.state).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn('Error message');

    // Act
    await tester.pumpWidget(_makeTestableWidget(SearchPage()));

    // Assert
    final emptyContainerFinder = find.byWidgetPredicate(
      (widget) => widget is Expanded && widget.child is Container,
    );
    expect(emptyContainerFinder, findsOneWidget);
  });

  testWidgets('should trigger search when text field is submitted', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockNotifier.state).thenReturn(RequestState.Empty);
    final tQuery = 'spiderman';

    // Act
    await tester.pumpWidget(_makeTestableWidget(SearchPage()));

    await tester.enterText(find.byType(TextField), tQuery);
    await tester.testTextInput.receiveAction(TextInputAction.search);

    // Assert
    verify(mockNotifier.fetchMultiSearch(tQuery));
  });
}
