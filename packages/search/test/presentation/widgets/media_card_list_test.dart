import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
// Sesuaikan path impor ini dengan lokasi file Anda
import 'package:search/domain/entities/media.dart';
import 'package:search/presentation/widgets/media_card_list.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    mockNavigatorObserver = MockNavigatorObserver();
    when(mockNavigatorObserver.navigator).thenReturn(null);
  });

  final tMovieMedia = Media(
    id: 1,
    title: 'Test Movie Title',
    posterPath: '/path.jpg',
    overview: 'This is a test overview for a movie.',
    mediaType: 'movie',
  );

  final tTvMedia = Media(
    id: 2,
    title: 'Test TV Title',
    posterPath: '/path.jpg',
    overview: 'This is a test overview for a TV show.',
    mediaType: 'tv',
  );

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(body: body),
      routes: {
        MovieDetailPage.routeName: (context) => FakeMovieDetailPage(),
        TvDetailPage.routeName: (context) => FakeTvDetailPage(),
      },
      navigatorObservers: [mockNavigatorObserver],
    );
  }

  testWidgets('should display movie information correctly', (
    WidgetTester tester,
  ) async {
    // Act
    await tester.pumpWidget(makeTestableWidget(MediaCard(tMovieMedia)));

    // Assert
    expect(find.text('Test Movie Title'), findsOneWidget);
    expect(find.text('This is a test overview for a movie.'), findsOneWidget);
  });

  testWidgets('should navigate to MovieDetailPage when movie card is tapped', (
    WidgetTester tester,
  ) async {
    // Act
    await tester.pumpWidget(makeTestableWidget(MediaCard(tMovieMedia)));

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    // Assert
    verify(mockNavigatorObserver.didPush(any, any));
    expect(find.byType(FakeMovieDetailPage), findsOneWidget);
  });

  testWidgets('should navigate to TvDetailPage when tv card is tapped', (
    WidgetTester tester,
  ) async {
    // Act
    await tester.pumpWidget(makeTestableWidget(MediaCard(tTvMedia)));

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    // Assert
    verify(mockNavigatorObserver.didPush(any, any));
    expect(find.byType(FakeTvDetailPage), findsOneWidget);
  });
}

class FakeMovieDetailPage extends StatelessWidget {
  const FakeMovieDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text('Movie Detail Page'));
  }
}

class FakeTvDetailPage extends StatelessWidget {
  const FakeTvDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text('TV Detail Page'));
  }
}
