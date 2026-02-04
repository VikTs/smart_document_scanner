import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_documents_scanner/models/document_type.dart';
import 'package:smart_documents_scanner/screens/document_view_screen.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/widgets/document_preview_card.dart';
import 'package:transparent_image/transparent_image.dart';

void main() {
  final testDocument = Document(
    id: "1",
    createdAt: DateTime.now(),
    type: DocumentType.idDocument, 
    file: kTransparentImage,
  );

  Widget makeTestableWidget(Widget child) {
    return EasyLocalization(
      path: 'assets/translations',
      supportedLocales: const [Locale('en'), Locale('it')],
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: MaterialApp(home: child),
    );
  }

  testWidgets('DocumentPreviewCard displays image and button', (tester) async {
    await tester.pumpWidget(makeTestableWidget(DocumentPreviewCard(document: testDocument)));

    expect(find.byType(Image), findsOneWidget);

    expect(find.text('document_details.view_document_btn'.tr()), findsOneWidget);
    expect(find.byIcon(Icons.open_in_new), findsOneWidget);
  });

  testWidgets('Tapping view button navigates to DocumentViewScreen', (tester) async {
    await tester.pumpWidget(makeTestableWidget(DocumentPreviewCard(document: testDocument)));

    final viewButton = find.text('document_details.view_document_btn'.tr());
    expect(viewButton, findsOneWidget);

    await tester.tap(viewButton);
    await tester.pumpAndSettle();

    expect(find.byType(DocumentViewScreen), findsOneWidget);
    expect(find.text('document_view.title'.tr()), findsOneWidget);
  });
}
