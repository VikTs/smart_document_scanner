import 'package:bloc_test/bloc_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_documents_scanner/core/models/document.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/data/db/converters/document_file_extension_converter.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_bloc.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_event.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_state.dart';
import 'package:smart_documents_scanner/screens/document_details/document_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

class MockDocumentsBloc extends MockBloc<DocumentsEvent, DocumentsState>
    implements DocumentsBloc {}

class FakeDocumentsEvent extends Fake implements DocumentsEvent {}

class FakeDocumentsState extends Fake implements DocumentsState {}

class _FakeAssetLoader extends AssetLoader {
  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    return {
      "document_details": {
        "share_document_btn": "Share",
        "recognize_document_btn": "Recognize",
        "delete_document_btn": "Delete",
      }
    };
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockDocumentsBloc documentsBloc;
  late DocumentData testDocument;

  setUpAll(() async {
    registerFallbackValue(FakeDocumentsEvent());
    registerFallbackValue(FakeDocumentsState());

    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() {
    documentsBloc = MockDocumentsBloc();

    whenListen(
      documentsBloc,
      Stream.value(DocumentsInitial()),
      initialState: DocumentsInitial(),
    );

    testDocument = DocumentData(
      id: 'doc_1',
      name: "doc_name",
      files: [
        DocumentFile(
          id: "2",
          documentId: "2",
          bytes: kTransparentImage,
          extension: DocumentFileExtension.jpg,
        ),
      ],
      createdAt: DateTime(2026, 2, 4),
    );
  });

  Widget _wrap(Widget child) {
    return EasyLocalization(
      supportedLocales: const [Locale('en')],
      fallbackLocale: const Locale('en'),
      path: 'assets/translations',
      assetLoader: _FakeAssetLoader(),
      child: MaterialApp(
        home: BlocProvider.value(
          value: documentsBloc,
          child: child,
        ),
      ),
    );
  }

  testWidgets('Displays document details screen correctly', (tester) async {
    await tester.pumpWidget(
      _wrap(
        DocumentDetailsScreen(
          document: testDocument,
          onDelete: (context, id) {},
          onShare: (files) {},
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byIcon(Icons.delete_outline), findsOneWidget);
  });
}