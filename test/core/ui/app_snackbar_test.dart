import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_documents_scanner/core/ui/app_snackbar.dart';

void main() {
  Widget _wrapWithApp() {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => Column(
            children: [
              ElevatedButton(
                onPressed: () =>
                    AppSnackbar.info(context, 'Info message'),
                child: const Text('Info'),
              ),
              ElevatedButton(
                onPressed: () =>
                    AppSnackbar.warning(context, 'Warning message'),
                child: const Text('Warning'),
              ),
              ElevatedButton(
                onPressed: () =>
                    AppSnackbar.error(context, 'Error message'),
                child: const Text('Error'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  testWidgets(
    'Shows info snackbar with correct message and color',
    (tester) async {
      await tester.pumpWidget(_wrapWithApp());

      await tester.tap(find.text('Info'));
      await tester.pump(); 
      await tester.pump(const Duration(milliseconds: 300)); 

      expect(find.text('Info message'), findsOneWidget);

      final material = tester.widget<Material>(
        find.byWidgetPredicate(
          (widget) =>
              widget is Material &&
              widget.color == const Color(0xFF2196F3),
        ),
      );

      expect(material.color, const Color(0xFF2196F3));

      await tester.pump(const Duration(seconds: 6));
    },
  );

  testWidgets(
    'Shows warning snackbar',
    (tester) async {
      await tester.pumpWidget(_wrapWithApp());

      await tester.tap(find.text('Warning'));
      await tester.pumpAndSettle();

      expect(find.text('Warning message'), findsOneWidget);

      await tester.pump(const Duration(seconds: 6));
    },
  );

  testWidgets(
    'Shows error snackbar',
    (tester) async {
      await tester.pumpWidget(_wrapWithApp());

      await tester.tap(find.text('Error'));
      await tester.pumpAndSettle();

      expect(find.text('Error message'), findsOneWidget);

      await tester.pump(const Duration(seconds: 6));
    },
  );

  testWidgets(
    'Closes snackbar when close icon is tapped',
    (tester) async {
      await tester.pumpWidget(_wrapWithApp());

      await tester.tap(find.text('Info'));
      await tester.pumpAndSettle();

      expect(find.text('Info message'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(find.text('Info message'), findsNothing);

      await tester.pump(const Duration(seconds: 6));
    },
  );

  testWidgets(
    'Snackbar disappears automatically after duration',
    (tester) async {
      await tester.pumpWidget(_wrapWithApp());

      await tester.tap(find.text('Info'));
      await tester.pump();

      expect(find.text('Info message'), findsOneWidget);

      await tester.pump(const Duration(seconds: 6));

      expect(find.text('Info message'), findsNothing);
    },
  );
}
