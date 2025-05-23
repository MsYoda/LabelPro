import 'dart:io';
import 'dart:ui' as ui;

import 'package:http/http.dart' as http;

String buildFileUrl({
  required String host,
  required int port,
  required String filePath,
}) {
  return 'http://$host:$port/api/file/?file_path=$filePath';
}

Future<ui.Size> getImageSize(String imageUrl) async {
  try {
    final response = await http.get(Uri.parse(imageUrl));
    print(imageUrl);
    if (response.statusCode == 200) {
      final codec = await ui.instantiateImageCodec(response.bodyBytes);
      final frame = await codec.getNextFrame();

      return ui.Size(
        frame.image.width.toDouble(),
        frame.image.height.toDouble(),
      );
    } else {
      throw HttpException(response.statusCode.toString());
    }
  } catch (e) {
    rethrow;
  }
}

String getFileExtension(String filePath) {
  String extension = filePath.split('.').last;
  return extension;
}
