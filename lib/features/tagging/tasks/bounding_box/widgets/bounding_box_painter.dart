import 'package:flutter/material.dart';

class BoundingBoxPainter extends CustomPainter {
  final Rect boundingBox;
  final double zoom;
  final String text;
  final Color color;

  BoundingBoxPainter({
    required this.boundingBox,
    required this.zoom,
    required this.color,
    required this.text,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final newRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(newRect, paint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();

    const horizontalPadding = 8;
    const verticalPadding = 4;

    final backgroundWidth = textPainter.width + 2 * horizontalPadding;
    final backgroundHeight = textPainter.height + 2 * verticalPadding;

    final backgroundRect = Rect.fromLTWH(
      newRect.left,
      newRect.top - 1,
      backgroundWidth,
      backgroundHeight,
    );

    final backgroundPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRect(backgroundRect, backgroundPaint);

    final textOffset = Offset(
      backgroundRect.left + (backgroundRect.width - textPainter.width) / 2,
      backgroundRect.top + (backgroundRect.height - textPainter.height) / 2,
    );

    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(BoundingBoxPainter oldDelegate) {
    return oldDelegate.boundingBox.left != boundingBox.left ||
        oldDelegate.boundingBox.right != boundingBox.right ||
        oldDelegate.boundingBox.top != boundingBox.top ||
        oldDelegate.boundingBox.bottom != boundingBox.bottom ||
        oldDelegate.text != text ||
        oldDelegate.zoom != zoom ||
        oldDelegate.color != color;
  }
}
