import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/models/document_type.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_bloc.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_state.dart';
import 'package:smart_documents_scanner/screens/document_details_screen.dart';
import 'package:smart_documents_scanner/widgets/document_card_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

class MockDocumentsBloc extends Mock implements DocumentsBloc {
  @override
  Stream<DocumentsState> get stream => const Stream.empty(); 
  @override
  DocumentsState get state => DocumentsInitial(); 
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DocumentsBloc mockBloc;
  late Document mockDocument;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() {
    mockBloc = MockDocumentsBloc();

    mockDocument = Document(
      id: "",
      file: kTransparentImage,
      type: DocumentType.receipt,
      createdAt: DateTime(2026, 2, 4, 15, 30),
    );
  });

  testWidgets('DocumentCardWidget displays content and navigates on tap',
      (tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: [Locale('en')],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
        child: MaterialApp(
          home: BlocProvider.value(
            value: mockBloc,
            child: DocumentCardWidget(document: mockDocument),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('document_types.receipt'), findsOneWidget);

    expect(
      find.textContaining('documents.document_card.date_label'),
      findsOneWidget,
    );

    expect(find.byIcon(Icons.open_in_new), findsOneWidget);

    await tester.tap(find.byType(DocumentCardWidget));
    await tester.pumpAndSettle();

    expect(find.byType(DocumentDetailsScreen), findsOneWidget);
  });
}
