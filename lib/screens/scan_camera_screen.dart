import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_documents_scanner/core/platform/photo.dart';

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
    final photo = await getLastPhoto();
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
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
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

class CameraPermissionDeniedView extends StatelessWidget {
  final VoidCallback onRetry;
  const CameraPermissionDeniedView({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "scan_document.camera_permission_error".tr(),
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: onRetry,
                    child: Text("scan_document.grant_permission_btn".tr()),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CameraPreviewView extends StatelessWidget {
  final CameraController controller;
  final File? lastPhoto;
  final VoidCallback onTakePicture;
  final VoidCallback onPickFromGallery;

  const CameraPreviewView({
    super.key,
    required this.controller,
    required this.lastPhoto,
    required this.onTakePicture,
    required this.onPickFromGallery,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: CameraPreview(controller)),
            TopBar(colorScheme: colorScheme),
            BottomControls(
              lastPhoto: lastPhoto,
              onTakePicture: onTakePicture,
              onPickFromGallery: onPickFromGallery,
              colorScheme: colorScheme,
            ),
          ],
        ),
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  final ColorScheme colorScheme;
  const TopBar({super.key, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.arrow_back,
                    color: colorScheme.onPrimary,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "scan_document.title".tr(),
                style: TextStyle(color: colorScheme.onPrimary, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomControls extends StatelessWidget {
  final File? lastPhoto;
  final VoidCallback onTakePicture;
  final VoidCallback onPickFromGallery;
  final ColorScheme colorScheme;

  const BottomControls({
    super.key,
    required this.lastPhoto,
    required this.onTakePicture,
    required this.onPickFromGallery,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 40,
            child: ElevatedButton(
              onPressed: onPickFromGallery,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: lastPhoto != null
                    ? Image.file(
                        lastPhoto!,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 56,
                        height: 56,
                        color: Colors.grey,
                        child: const Icon(Icons.photo, color: Colors.white),
                      ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: onTakePicture,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(56),
              ),
            ),
            child: Icon(
              Icons.camera_alt,
              color: colorScheme.onPrimary,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
