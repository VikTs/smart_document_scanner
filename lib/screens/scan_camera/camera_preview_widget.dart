import 'dart:io';

import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
