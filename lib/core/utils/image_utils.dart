import 'dart:io';
import 'dart:ui' as ui;

import 'package:http/http.dart' as http;

String buildUrl(String filePath) {
  return 'http://localhost:8080/file?file_path=$filePath';
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
