import 'package:flutter_test/flutter_test.dart';
import 'package:rescue_mobile_models/rescue_mobile_models.dart';

void main() {
  test('SosStatus has platform values', () {
    expect(SosStatus.created.value, 'CREATED');
    expect(SosStatus.completed.value, 'COMPLETED');
  });
}
