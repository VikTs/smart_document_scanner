import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_documents_scanner/core/models/document.dart';
import 'package:smart_documents_scanner/core/models/document_file_extension.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/screens/document_details/document_actions_widget.dart';

void main() {
  late bool deleteCalled;
  late bool shareCalled;
  late bool recognizeCalled;

  late DocumentData imageDocument;
  late DocumentData pdfDocument;

  DocumentFile imageFile(String docId) {
    return DocumentFile(
      id: 'file_1',
      documentId: docId,
      bytes: Uint8List.fromList([1, 2, 3]),
      extension: DocumentFileExtension.jpg,
      pageNumber: 0,
    );
  }

  DocumentFile pdfFile(String docId) {
    return DocumentFile(
      id: 'file_2',
      documentId: docId,
      bytes: Uint8List.fromList([4, 5, 6]),
      extension: DocumentFileExtension.pdf,
      pageNumber: 0,
    );
  }

  setUp(() {
    deleteCalled = false;
    shareCalled = false;
    recognizeCalled = false;

    imageDocument = DocumentData(
      id: 'doc_1',
      name: 'Image doc',
      createdAt: DateTime.now(),
      files: [imageFile('doc_1')],
    );

    pdfDocument = DocumentData(
      id: 'doc_2',
      name: 'Pdf doc',
      createdAt: DateTime.now(),
      files: [pdfFile('doc_2')],
    );
  });

  Widget buildWidget(DocumentData document) {
    return MaterialApp(
      home: Material(
        child: DocumentActions(
          areActionsDisabled: false,
          document: document,
          onDelete: (context, id) => deleteCalled = true,
          onShare: (_) => shareCalled = true,
          onRecognize: (files) => recognizeCalled = true,
        ),
      ),
    );
  }

  testWidgets('shows share and recognize buttons for image document',
      (tester) async {
    await tester.pumpWidget(buildWidget(imageDocument));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.share_outlined), findsOneWidget);
    expect(find.byIcon(Icons.text_snippet_outlined), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);
  });

  testWidgets('hides share and recognize for non-image document',
      (tester) async {
    await tester.pumpWidget(buildWidget(pdfDocument));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.share_outlined), findsNothing);
    expect(find.byIcon(Icons.text_snippet_outlined), findsNothing);
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);
  });

  testWidgets('calls share callback', (tester) async {
    await tester.pumpWidget(buildWidget(imageDocument));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.share_outlined));
    await tester.pump();

    expect(shareCalled, isTrue);
  });

  testWidgets('calls recognize callback', (tester) async {
    await tester.pumpWidget(buildWidget(imageDocument));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.text_snippet_outlined));
    await tester.pump();

    expect(recognizeCalled, isTrue);
  });

  testWidgets('calls delete callback', (tester) async {
    await tester.pumpWidget(buildWidget(imageDocument));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pump();

    expect(deleteCalled, isTrue);
  });
}