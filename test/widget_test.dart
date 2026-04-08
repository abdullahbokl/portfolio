import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/app/app.dart';

void main() {
  testWidgets('Portfolio app renders hero section', (WidgetTester tester) async {
    await tester.pumpWidget(const PortfolioApp());
    await tester.pumpAndSettle();

    expect(find.text('Abdullah Khaled Elbokl'), findsOneWidget);
  });
}
