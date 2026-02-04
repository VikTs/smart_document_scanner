import 'dart:io';
import 'package:photo_manager/photo_manager.dart';

Future<File?> getLastPhoto() async {
  final permission = await PhotoManager.requestPermissionExtend();
  if (!permission.isAuth) return null;

  final albums = await PhotoManager.getAssetPathList(
    type: RequestType.image,
    onlyAll: true,
  );

  if (albums.isEmpty) return null;

  final recentAlbum = albums.first;
  final recentAssets = await recentAlbum.getAssetListRange(start: 0, end: 1);

  if (recentAssets.isEmpty) return null;

  final file = await recentAssets.first.file;
  return file;
}
