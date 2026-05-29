import 'package:flutter_test/flutter_test.dart';
import 'package:rescue_user_app/main.dart';

void main() {
  testWidgets('User app shows Emergency SOS', (WidgetTester tester) async {
    await tester.pumpWidget(const RescueUserApp());
    expect(find.text('Emergency SOS'), findsOneWidget);
  });
}
