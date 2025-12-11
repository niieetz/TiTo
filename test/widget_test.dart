// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:tito/main.dart';
import 'package:tito/common/consts.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the launcher UI is shown.
    expect(find.text('Select an app to launch:'), findsOneWidget);
    // The button to launch the Pace2Distance app should exist
    expect(find.text(pace2distance), findsOneWidget);
  });
}
