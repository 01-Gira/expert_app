import 'package:search/domain/entities/media.dart';
import 'package:search/presentation/bloc/search/search_bloc.dart';
import 'package:search/presentation/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockSearchBloc mockSearchBloc;

  setUp(() {
    mockSearchBloc = MockSearchBloc();
    when(mockSearchBloc.stream).thenAnswer((_) => Stream.empty());
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<SearchBloc>.value(
      value: mockSearchBloc,
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

  testWidgets('should display loading indicator when state is SearchLoading', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockSearchBloc.state).thenReturn(SearchLoading());

    // Act
    await tester.pumpWidget(makeTestableWidget(SearchPage()));

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display ListView when state is SearchLoaded', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockSearchBloc.state).thenReturn(SearchLoaded(tMediaList));

    // Act
    await tester.pumpWidget(makeTestableWidget(SearchPage()));

    // Assert
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('should display Text with message when state is SearchError', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockSearchBloc.state).thenReturn(SearchError('Error message'));

    // Act
    await tester.pumpWidget(makeTestableWidget(SearchPage()));

    // Assert
    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('should display initial text when state is SearchEmpty', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockSearchBloc.state).thenReturn(SearchEmpty());

    // Act
    await tester.pumpWidget(makeTestableWidget(SearchPage()));

    // Assert
    expect(find.text('Find movies or tv shows!'), findsOneWidget);
  });

  testWidgets('should add OnQueryChanged event when text field is changed', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockSearchBloc.state).thenReturn(SearchEmpty());
    final tQuery = 'spiderman';

    // Act
    await tester.pumpWidget(makeTestableWidget(SearchPage()));

    final textField = find.byType(TextField);
    await tester.enterText(textField, tQuery);
    await tester.pump(const Duration(milliseconds: 500));

    // Assert
    verify(mockSearchBloc.add(OnQueryChanged(tQuery))).called(1);
  });
}
