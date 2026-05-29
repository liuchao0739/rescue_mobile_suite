import 'package:flutter_test/flutter_test.dart';
import 'package:rescue_worker_app/main.dart';

void main() {
  testWidgets('Worker app shows Available Orders', (WidgetTester tester) async {
    await tester.pumpWidget(const RescueWorkerApp());
    expect(find.text('Available Orders'), findsOneWidget);
  });
}
