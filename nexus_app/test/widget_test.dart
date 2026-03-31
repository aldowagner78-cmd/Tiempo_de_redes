import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_control/main.dart';

void main() {
  testWidgets('App starts correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NexusControlApp());

    // Verify the app name appears
    expect(find.text('NEXUS CONTROL'), findsOneWidget);
  });
}
