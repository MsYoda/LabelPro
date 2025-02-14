import 'package:flutter/material.dart';

class DragPoint extends StatefulWidget {
  final Function(Offset) onMovePoint;
  final Function(Offset) onStartMove;
  final Function() onMoveEnd;
  final MouseCursor cursor;

  const DragPoint({
    required this.onMovePoint,
    required this.onStartMove,
    required this.onMoveEnd,
    this.cursor = MouseCursor.defer,
    super.key,
  });

  @override
  State<DragPoint> createState() => _DragPointState();
}

class _DragPointState extends State<DragPoint> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (details) {
        widget.onStartMove(details.localPosition);
      },
      onPanUpdate: (details) {
        widget.onMovePoint(details.localPosition);
      },
      onPanEnd: (_) {
        widget.onMoveEnd();
      },
      onPanCancel: () {
        widget.onMoveEnd();
      },
      child: Container(
        width: 15,
        height: 15,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
        ),
      ),
    );
  }
}
