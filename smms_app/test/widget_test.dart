import 'package:flutter_test/flutter_test.dart';
import 'package:smms_app/main.dart';

void main() {
  testWidgets('App launches correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const SMSSApp());
    expect(find.text('SMMS'), findsOneWidget);
  });
}
