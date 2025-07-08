import 'dart:io';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

Future<void> downloadFile(
  String url,
  String fileName, {
  void Function(double progress)? onProgress,
}) async {
  try {
    Dio dio = Dio();

    // Get device's download directory (or temp for iOS)
    Directory dir = Platform.isAndroid ? (await getExternalStorageDirectory())! : await getApplicationDocumentsDirectory();

    String savePath = "${dir.path}/$fileName";

    await dio.download(
      url,
      savePath,
      onReceiveProgress: (received, total) {
        if (total != -1 && onProgress != null) {
          print("${(received / total * 100).toStringAsFixed(0)}%");
          onProgress(received / total);
        }
      },
    );

    final result = await OpenFile.open(savePath);
    print("Open result: ${result.message}");
    print("File saved to $savePath");
  } catch (e) {
    print("Download failed: $e");
    rethrow;
  }
}
