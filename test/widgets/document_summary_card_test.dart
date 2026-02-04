import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/models/document_type.dart';
import 'package:smart_documents_scanner/widgets/document_summary_card.dart';
import 'package:transparent_image/transparent_image.dart';

extension FakeTr on String {
  String tr() => this;
}

void main() {
  testWidgets('DocumentSummaryCard displays content correctly', (tester) async {
    final testDocument = Document(
      id: "",
      file: kTransparentImage,
      type: DocumentType.receipt,
      createdAt: DateTime.now(),
      placeType: 'store',
      documentDate: DateTime(2026, 2, 4),
      totalAmount: 123.45,
      currency: 'USD',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DocumentSummaryCard(document: testDocument),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('document_details.items.document_type'), findsOneWidget);
    expect(find.text('document_types.receipt'), findsOneWidget);
    expect(find.text('document_details.items.merchant'), findsOneWidget);
    expect(find.text('places.store'), findsOneWidget);
    expect(find.text('document_details.items.date'), findsOneWidget);

    final dateTextFinder = find.textContaining('2026');
    expect(dateTextFinder, findsOneWidget);

    expect(find.text('document_details.items.total'), findsOneWidget);
    expect(find.text('123.45 USD'), findsOneWidget);

    final totalText = tester.widget<Text>(find.text('123.45 USD'));
    expect(totalText.style?.fontWeight, FontWeight.bold);
  });
}
