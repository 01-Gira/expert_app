import 'package:expert_app/presentation/pages/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget(Widget body) {
    return MaterialApp(home: body);
  }

  testWidgets('AboutPage should display its content correctly', (
    WidgetTester tester,
  ) async {
    // Act
    await tester.pumpWidget(makeTestableWidget(AboutPage()));

    // Assert
    final imageFinder = find.byType(Image);
    expect(imageFinder, findsOneWidget);

    final textFinder = find.text(
      'expert_app merupakan sebuah aplikasi katalog film yang dikembangkan oleh Dicoding Indonesia sebagai contoh proyek aplikasi untuk kelas Menjadi Flutter Developer Expert.',
      findRichText: true,
    );
    expect(textFinder, findsOneWidget);

    final backButtonFinder = find.byIcon(Icons.arrow_back);
    expect(backButtonFinder, findsOneWidget);
  });
}
