import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_bloc.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_state.dart';
import 'package:smart_documents_scanner/screens/home_screen.dart';
import 'package:smart_documents_scanner/widgets/empty_widget.dart';

class MockDocumentsBloc extends Mock implements DocumentsBloc {}

class FakeDocumentsState extends Fake implements DocumentsState {}

void main() {
  late MockDocumentsBloc documentsBloc;

  setUpAll(() {
    registerFallbackValue(FakeDocumentsState());
  });

  setUp(() {
    documentsBloc = MockDocumentsBloc();
  });

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: BlocProvider<DocumentsBloc>.value(
        value: documentsBloc,
        child: child,
      ),
    );
  }

  testWidgets('Shows loading indicator when state is DocumentsLoading', (
    tester,
  ) async {
    when(() => documentsBloc.state).thenReturn(DocumentsLoading());
    when(() => documentsBloc.stream).thenAnswer(
      (_) => Stream<DocumentsState>.fromIterable([DocumentsLoading()]),
    );

    await tester.pumpWidget(makeTestableWidget(const HomeScreen()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Shows empty widget when state is DocumentsEmpty', (
    tester,
  ) async {
    when(() => documentsBloc.state).thenReturn(DocumentsEmpty());
    when(() => documentsBloc.stream).thenAnswer(
      (_) => Stream<DocumentsState>.fromIterable([DocumentsEmpty()]),
    );

    await tester.pumpWidget(makeTestableWidget(const HomeScreen()));
    expect(find.byType(EmptyWidget), findsOneWidget);
    final scanButton = find.text('home.scan_document_btn'.tr());
    expect(scanButton, findsOneWidget);
  });

  testWidgets('Shows error message when state is DocumentsError', (
    tester,
  ) async {
    when(
      () => documentsBloc.state,
    ).thenReturn(DocumentsError('Error occurred'));
    when(() => documentsBloc.stream).thenAnswer(
      (_) => Stream<DocumentsState>.fromIterable([
        DocumentsError('Error occurred'),
      ]),
    );

    await tester.pumpWidget(makeTestableWidget(const HomeScreen()));
    expect(find.text('Error occurred'), findsOneWidget);
  });
}
