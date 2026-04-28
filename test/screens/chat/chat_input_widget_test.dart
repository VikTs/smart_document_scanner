import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_documents_scanner/screens/chat/chat_input_widget.dart';

void main() {
  testWidgets('ChatInput sends message and clears controller', (tester) async {
    final controller = TextEditingController();
    var called = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChatInput(
            controller: controller,
            onSend: () => called = true,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Hello');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();

    expect(called, true);
    expect(controller.text, isEmpty);
  });
}