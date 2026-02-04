import 'dart:io';
import 'package:photo_manager/photo_manager.dart';

Future<File?> getLastPhoto() async {
  final permission = await PhotoManager.requestPermissionExtend();
  if (!permission.isAuth) return null;

  final filter = FilterOptionGroup(
    orders: [const OrderOption(type: OrderOptionType.updateDate, asc: false)],
  );

  final albums = await PhotoManager.getAssetPathList(
    type: RequestType.image,
    onlyAll: true,
    filterOption: filter,
  );

  if (albums.isEmpty) return null;

  final assets = await albums.first.getAssetListPaged(page: 0, size: 1);
  if (assets.isEmpty) return null;

  return await assets.first.file;
}
