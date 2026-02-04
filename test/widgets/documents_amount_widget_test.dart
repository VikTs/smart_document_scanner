import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/models/document_type.dart';
import 'package:smart_documents_scanner/widgets/documents_amount_widget.dart';
import 'package:transparent_image/transparent_image.dart';

extension FakeTr on String {
  String tr() => this;
}

void main() {
  testWidgets('DocumentsAmountWidget displays correct count and label', (tester) async {
    final documents = [
      Document(id: '1', file: kTransparentImage, type: DocumentType.unknown, createdAt: DateTime.now()),
      Document(id: '2', file: kTransparentImage, type: DocumentType.unknown, createdAt: DateTime.now()),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DocumentsAmountWidget(documents: documents),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('home.scanned_documents_amount_title'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.byIcon(Icons.document_scanner_outlined), findsOneWidget);
  });
}
