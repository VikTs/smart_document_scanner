import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:smart_documents_scanner/core/models/document.dart';
import 'package:smart_documents_scanner/core/models/document_file_extension.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_bloc.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_event.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_state.dart';
import 'package:smart_documents_scanner/screens/document_details/document_details_screen.dart';

class MockDocumentsBloc extends MockBloc<DocumentsEvent, DocumentsState> implements DocumentsBloc {}

class FakeDocumentsState extends Fake implements DocumentsState {}

class FakeDocumentsEvent extends Fake implements DocumentsEvent {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(FakeDocumentsState());
    registerFallbackValue(FakeDocumentsEvent());
  });

  late MockDocumentsBloc mockBloc;

  const bytes = [
    71, 73, 70, 56, 57, 97, 1, 0, 1, 0, 128, 0, 0, 0, 0, 0, 255, 255, 255, 33, 249, 4, 1, 0, 0, 1, 
    0, 44, 0, 0, 0, 0, 1, 0, 1, 0, 0, 2, 2, 68, 1, 0, 59
    ];

  final testDocument = DocumentData(
    id: '1',
    name: 'Test document',
    createdAt: DateTime(2025, 1, 1),
    files: [
      DocumentFile(
        id: 'file_1',
        documentId: '1',
        bytes: Uint8List.fromList(bytes),
        extension: DocumentFileExtension.jpg,
        pageNumber: 1,
      ),
    ],
  );

  setUp(() {
    mockBloc = MockDocumentsBloc();

    when(() => mockBloc.state).thenReturn(DocumentsLoaded([testDocument]));

    whenListen(
      mockBloc,
      Stream<DocumentsState>.fromIterable([
        DocumentsLoaded([testDocument]),
      ]),
      initialState: DocumentsLoaded([testDocument]),
    );
  });

  Widget buildWidget() {
    return EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      saveLocale: false,
      child: BlocProvider<DocumentsBloc>.value(
        value: mockBloc,
        child: MaterialApp(
          locale: const Locale('en'),
          home: DocumentDetailsScreen(documentId: '1', onDelete: (_, __) {}, onShare: (_) {}),
        ),
      ),
    );
  }

  testWidgets('Displays document details screen correctly', (tester) async {
    await tester.pumpWidget(buildWidget());

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(DocumentDetailsScreen), findsOneWidget);

    expect(find.text('Test document'), findsOneWidget);

    expect(find.byType(Scaffold), findsOneWidget);

    expect(find.byType(FloatingActionButton), findsOneWidget);

    expect(find.byIcon(Icons.chat), findsOneWidget);
  });
}
