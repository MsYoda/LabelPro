import 'dart:io';
import 'dart:ui' as ui;

import 'package:http/http.dart' as http;

Future<ui.Size> getImageSize(String imageUrl) async {
  try {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      final codec = await ui.instantiateImageCodec(response.bodyBytes);
      final frame = await codec.getNextFrame();

      return ui.Size(
        frame.image.width.toDouble(),
        frame.image.height.toDouble(),
      );
    } else {
      throw HttpException('');
    }
  } catch (e) {
    rethrow;
  }
}
