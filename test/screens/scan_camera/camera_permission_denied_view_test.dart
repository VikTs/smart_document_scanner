import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_documents_scanner/screens/scan_camera/camera_permition_denied_widget.dart';

void main() {
  testWidgets('shows permission error text and retry button',
      (WidgetTester tester) async {
    bool retryCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: CameraPermissionDeniedView(
          onRetry: () => retryCalled = true,
        ),
      ),
    );

    expect(find.byType(Text), findsWidgets);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });

  testWidgets('calls onRetry when button is pressed',
      (WidgetTester tester) async {
    bool retryCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: CameraPermissionDeniedView(
          onRetry: () => retryCalled = true,
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(retryCalled, isTrue);
  });

  testWidgets('pops navigator when back icon tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Navigator(
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (_) => CameraPermissionDeniedView(
              onRetry: () {},
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.byType(CameraPermissionDeniedView), findsNothing);
  });
}