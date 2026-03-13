import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_bloc.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_event.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_state.dart';
import 'package:smart_documents_scanner/screens/document_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

class MockDocumentsBloc extends MockBloc<DocumentsEvent, DocumentsState>
    implements DocumentsBloc {}

class FakeDocumentsEvent extends Fake implements DocumentsEvent {}

class FakeDocumentsState extends Fake implements DocumentsState {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DocumentsBloc documentsBloc;
  late Document testDocument;

  setUpAll(() async {
    registerFallbackValue(FakeDocumentsEvent());
    registerFallbackValue(FakeDocumentsState());

    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() {
    documentsBloc = MockDocumentsBloc();

    when(() => documentsBloc.state).thenReturn(DocumentsInitial());

    testDocument = Document(
      id: 'doc_1',
      name: "doc_name",
      file: kTransparentImage,
      createdAt: DateTime(2026, 2, 4),
    );
  });

  Widget _wrap(Widget child) {
    return EasyLocalization(
      supportedLocales: const [Locale('en')],
      fallbackLocale: const Locale('en'),
      path: 'assets/translations',
      child: MaterialApp(
        home: BlocProvider.value(value: documentsBloc, child: child),
      ),
    );
  }

  testWidgets('Displays document details screen correctly', (tester) async {
    await tester.pumpWidget(
      _wrap(DocumentDetailsScreen(document: testDocument, onDelete: (BuildContext p1, String p2) {  }, onShare: (Uint8List p1) {  }, onAddFile: (BuildContext p1) {  },)),
    );

    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.delete), findsOneWidget);
  });
}
