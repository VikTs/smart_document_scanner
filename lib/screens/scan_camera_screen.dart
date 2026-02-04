import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_documents_scanner/core/platform/photo.dart';

class ScanCameraScreen extends StatefulWidget {
  const ScanCameraScreen({super.key});

  @override
  State<ScanCameraScreen> createState() => _ScanCameraScreenState();
}

class _ScanCameraScreenState extends State<ScanCameraScreen> {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;
  File? _lastPhoto;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _loadLastPhoto();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
    );

    _controller = CameraController(
      backCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    _initializeControllerFuture = _controller!.initialize();
    setState(() {});
  }

  Future<void> _loadLastPhoto() async {
    final photo = await getLastPhoto();
    if (!mounted) return;
    setState(() {
      _lastPhoto = photo;
    });
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

  Future<void> _takePicture() async {
    await _initializeControllerFuture;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorSchemeTheme = theme.colorScheme;

    if (_controller == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: FutureBuilder(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CameraPreview(_controller!);
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),

            Positioned(
              top: 0,
              left: 0,
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
                            color: colorSchemeTheme.onPrimary,
                            size: 28,
                          ),
                        ),
                      ),
                      Text(
                        "scan_document.title".tr(),
                        style: TextStyle(
                          color: colorSchemeTheme.onPrimary,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 50,
                    child: ElevatedButton(
                      onPressed: _pickFromGallery,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: _lastPhoto != null
                            ? Image.file(
                                _lastPhoto!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey,
                                child: const Icon(
                                  Icons.photo,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: _takePicture,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorSchemeTheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 28,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(56),
                      ),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: colorSchemeTheme.onPrimary,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
