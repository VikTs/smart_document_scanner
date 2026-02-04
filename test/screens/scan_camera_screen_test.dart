import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:camera/camera.dart';
import 'package:smart_documents_scanner/screens/scan_camera_screen.dart';

class MockCameraController extends Mock implements CameraController {}
class MockXFile extends Mock implements XFile {}

void main() {
  late MockCameraController mockController;

  setUp(() {
    mockController = MockCameraController();
    when(() => mockController.initialize()).thenAnswer((_) async {});
    when(() => mockController.dispose()).thenAnswer((_) async {});
    when(() => mockController.takePicture())
        .thenAnswer((_) async => MockXFile());
  });

  testWidgets('ScanCameraScreen shows loading initially', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ScanCameraScreen()),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
