import 'package:bloc_test/bloc_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:smart_documents_scanner/presentation/bloc/documents_bloc.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_state.dart';
import 'package:smart_documents_scanner/screens/documents_screen.dart';

import 'document_details_screen_test.dart';

void main() {
  late DocumentsBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeDocumentsState());
    registerFallbackValue(FakeDocumentsEvent());
  });

  setUp(() {
    mockBloc = MockDocumentsBloc();
  });

  Future<void> pumpDocumentsScreen(WidgetTester tester, DocumentsState state) async {
    when(() => mockBloc.state).thenReturn(state);
    whenListen(mockBloc, Stream.fromIterable([state]));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<DocumentsBloc>.value(
          value: mockBloc,
          child: const DocumentsScreen(),
        ),
      ),
    );

    await tester.pump(); 
  }

  testWidgets('shows error state', (tester) async {
    await pumpDocumentsScreen(tester, DocumentsError('Boom'));

    expect(find.text('Boom'), findsOneWidget);
  });

    testWidgets('shows loading state', (tester) async {
    await pumpDocumentsScreen(tester, DocumentsLoading());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

    testWidgets('shows empty state', (tester) async {
    await pumpDocumentsScreen(tester, DocumentsEmpty());
    final translatedText = 'documents.empty.title'.tr(); 

    expect(find.textContaining(translatedText), findsOneWidget);
  });

}

