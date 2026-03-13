import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_documents_scanner/core/models/document.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/widgets/documents_amount_widget.dart';
import 'package:transparent_image/transparent_image.dart';

extension FakeTr on String {
  String tr() => this;
}

void main() {
  testWidgets('DocumentsAmountWidget displays correct count and label', (
    tester,
  ) async {
    final documents = [
      DocumentData(
        id: '1',
        files: [
          DocumentFile(
            id: "1",
            documentId: "1",
            bytes: kTransparentImage,
            type: 0,
          ),
        ],
        name: "",
        createdAt: DateTime.now(),
      ),
      DocumentData(
        id: '2',
        files: [
          DocumentFile(
            id: "2",
            documentId: "2",
            bytes: kTransparentImage,
            type: 0,
          ),
        ],
        name: "",
        createdAt: DateTime.now(),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: DocumentsAmountWidget(documents: documents)),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('home.scanned_documents_amount_title'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.byIcon(Icons.document_scanner_outlined), findsOneWidget);
  });
}
