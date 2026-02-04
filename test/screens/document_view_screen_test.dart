import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_documents_scanner/screens/document_view_screen.dart';
import 'package:transparent_image/transparent_image.dart';

void main() {
  Widget _wrap(Widget child) {
    return MaterialApp(
      home: child,
    );
  }

  testWidgets('Displays image and title correctly', (tester) async {
    await tester.pumpWidget(
      _wrap(
        DocumentViewScreen(
          imageBytes: kTransparentImage,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(InteractiveViewer), findsOneWidget);
  });
}
