import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_documents_scanner/core/services/photo_service.dart';
import 'package:smart_documents_scanner/core/themes/app_colors.dart';
import 'package:smart_documents_scanner/screens/scan_camera/camera_permition_denied_widget.dart';
import 'package:smart_documents_scanner/screens/scan_camera/camera_preview_widget.dart';

class ScanCameraScreen extends StatefulWidget {
  const ScanCameraScreen({super.key});

  @override
  State<ScanCameraScreen> createState() => _ScanCameraScreenState();
}

class _ScanCameraScreenState extends State<ScanCameraScreen> {
  CameraController? _controller;
  bool _isLoading = true;
  bool _permissionDenied = false;
  File? _lastPhoto;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initCamera();
      _loadLastPhoto();
    });
  }

  Future<void> _loadLastPhoto() async {
    final photo = await PhotoService.getLastPhoto();
    if (!mounted) return;
    setState(() => _lastPhoto = photo);
  }

  Future<bool> _checkAndRequestCameraPermission() async {
    PermissionStatus status = await Permission.camera.status;
    if (status.isGranted) return true;

    status = await Permission.camera.request();

    await Future.delayed(const Duration(milliseconds: 500));
    status = await Permission.camera.status;

    return status.isGranted;
  }

  Future<void> _initCamera() async {
    setState(() {
      _isLoading = true;
      _permissionDenied = false;
    });

    final hasPermission = await _checkAndRequestCameraPermission();

    if (!hasPermission) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _permissionDenied = true;
      });
      return;
    }

    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
      );

      _controller = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();

      if (!mounted) return;
      setState(() => _isLoading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    final directory = await getTemporaryDirectory();
    final filePath = path.join(
      directory.path,
      '${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    final image = await _controller!.takePicture();
    await image.saveTo(filePath);

    if (!mounted) return;
    Navigator.pop(context, filePath);
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null && mounted) {
      Navigator.pop(context, pickedFile.path);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: colorScheme.cameraBackground,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_permissionDenied) {
      return CameraPermissionDeniedView(onRetry: _initCamera);
    }

    return CameraPreviewView(
      controller: _controller!,
      lastPhoto: _lastPhoto,
      onPickFromGallery: _pickFromGallery,
      onTakePicture: _takePicture,
    );
  }
}
