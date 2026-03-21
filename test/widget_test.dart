import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/main.dart';

void main() {
  testWidgets('Portfolio loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const PortfolioApp());
    expect(find.text('portfolio.sh'), findsOneWidget);
  });
}
