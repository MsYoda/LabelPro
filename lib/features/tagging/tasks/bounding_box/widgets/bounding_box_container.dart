import 'package:flutter/material.dart';
import 'package:label_pro_client/core_ui/drag_point.dart';
import 'package:label_pro_client/domain/models/bounding_box.dart';
import 'package:label_pro_client/features/tagging/tasks/bounding_box/utils/rect_ext.dart';

import 'bounding_box_painter.dart';

class BoundingBoxContainer extends StatefulWidget {
  const BoundingBoxContainer({
    super.key,
    required this.box,
    required this.zoom,
    required this.isEditing,
    required this.onMove,
    required this.onChangeSize,
    required this.onStartDrag,
    required this.onEndDrag,
    required this.isDragged,
    required this.color,
  });

  final Color color;
  final Polygon box;
  final double zoom;
  final bool isEditing;
  final bool isDragged;
  final void Function(Offset dragOffset) onMove;
  final void Function(Rect newRect) onChangeSize;
  final Function() onStartDrag;
  final Function() onEndDrag;

  @override
  State<BoundingBoxContainer> createState() => _BoundingBoxContainerState();
}

class _BoundingBoxContainerState extends State<BoundingBoxContainer> {
  bool widthNegative = false;
  bool heightNegative = false;

  Offset startPos = Offset.zero;

  void onChangeSizeEnd() {
    widget.onEndDrag();
    if (widget.box.box.width.isNegative || widget.box.box.width == 0) {
      setState(() {
        widthNegative = true;
      });
    } else {
      setState(() {
        widthNegative = false;
      });
    }
    if (widget.box.box.height.isNegative || widget.box.box.height == 0) {
      setState(() {
        heightNegative = true;
      });
    } else {
      setState(() {
        heightNegative = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final correctBox = widget.box.box.withCorrectCorners;
    return IgnorePointer(
      ignoring: !widget.isEditing,
      child: GestureDetector(
        behavior: widget.isEditing ? HitTestBehavior.opaque : null,
        onPanDown: (_) {
          widget.onStartDrag();
        },
        onPanUpdate: (details) {
          widget.onMove(details.delta);
        },
        onPanEnd: (_) {
          widget.onEndDrag();
        },
        child: MouseRegion(
          cursor: widget.isDragged
              ? SystemMouseCursors.grabbing
              : widget.isEditing
                  ? SystemMouseCursors.grab
                  : MouseCursor.defer,
          child: SizedBox(
            width: correctBox.width * widget.zoom,
            height: correctBox.height * widget.zoom,
            child: Stack(
              children: [
                if (widget.isEditing)
                  Container(
                    color: widget.color.withValues(alpha: 0.25),
                  ),
                IgnorePointer(
                  child: CustomPaint(
                    size: Size(
                      correctBox.width * widget.zoom,
                      correctBox.height * widget.zoom,
                    ),
                    foregroundPainter: BoundingBoxPainter(
                      boundingBox: widget.box.box,
                      zoom: widget.zoom,
                      color: widget.color,
                      text: widget.box.label.name,
                    ),
                  ),
                ),
                if (widget.isEditing)
                  Stack(
                    children: [
                      Positioned(
                        right: -4,
                        bottom: -4,
                        child: DragPoint(
                          onStartMove: (offset) {
                            widget.onStartDrag();
                            startPos = Offset(
                              widthNegative
                                  ? (widget.box.box.left) * widget.zoom - offset.dx
                                  : (widget.box.box.right) * widget.zoom - offset.dx,
                              heightNegative
                                  ? (widget.box.box.top) * widget.zoom - offset.dy
                                  : (widget.box.box.bottom) * widget.zoom - offset.dy,
                            );
                          },
                          onMovePoint: (offset) {
                            widget.onChangeSize(
                              Rect.fromLTRB(
                                widthNegative
                                    ? offset.dx + startPos.dx
                                    : widget.box.box.left * widget.zoom,
                                heightNegative
                                    ? offset.dy + startPos.dy
                                    : widget.box.box.top * widget.zoom,
                                widthNegative
                                    ? widget.box.box.right * widget.zoom
                                    : offset.dx + startPos.dx,
                                heightNegative
                                    ? widget.box.box.bottom * widget.zoom
                                    : offset.dy + startPos.dy,
                              ),
                            );
                          },
                          onMoveEnd: onChangeSizeEnd,
                        ),
                      ),
                      Positioned(
                        left: -4,
                        top: -4,
                        child: DragPoint(
                          onStartMove: (offset) {
                            widget.onStartDrag();
                            setState(
                              () {
                                startPos = Offset(
                                  widthNegative
                                      ? (widget.box.box.right) * widget.zoom - offset.dx
                                      : (widget.box.box.left) * widget.zoom - offset.dx,
                                  heightNegative
                                      ? (widget.box.box.bottom) * widget.zoom - offset.dy
                                      : (widget.box.box.top) * widget.zoom - offset.dy,
                                );
                              },
                            );
                          },
                          onMovePoint: (offset) {
                            widget.onChangeSize(
                              Rect.fromLTRB(
                                widthNegative
                                    ? widget.box.box.left * widget.zoom
                                    : offset.dx + startPos.dx,
                                heightNegative
                                    ? widget.box.box.top * widget.zoom
                                    : offset.dy + startPos.dy,
                                widthNegative
                                    ? offset.dx + startPos.dx
                                    : widget.box.box.right * widget.zoom,
                                heightNegative
                                    ? offset.dy + startPos.dy
                                    : widget.box.box.bottom * widget.zoom,
                              ),
                            );
                          },
                          onMoveEnd: onChangeSizeEnd,
                        ),
                      ),
                      Positioned(
                        left: -4,
                        bottom: -4,
                        child: DragPoint(
                          onStartMove: (offset) {
                            widget.onStartDrag();
                            startPos = Offset(
                              widthNegative
                                  ? (widget.box.box.right) * widget.zoom - offset.dx
                                  : (widget.box.box.left) * widget.zoom - offset.dx,
                              heightNegative
                                  ? (widget.box.box.top) * widget.zoom - offset.dy
                                  : (widget.box.box.bottom) * widget.zoom - offset.dy,
                            );
                          },
                          onMovePoint: (offset) {
                            widget.onChangeSize(
                              Rect.fromLTRB(
                                widthNegative
                                    ? widget.box.box.left * widget.zoom
                                    : offset.dx + startPos.dx,
                                heightNegative
                                    ? offset.dy + startPos.dy
                                    : widget.box.box.top * widget.zoom,
                                widthNegative
                                    ? offset.dx + startPos.dx
                                    : widget.box.box.right * widget.zoom,
                                heightNegative
                                    ? widget.box.box.bottom * widget.zoom
                                    : offset.dy + startPos.dy,
                              ),
                            );
                          },
                          onMoveEnd: onChangeSizeEnd,
                        ),
                      ),
                      Positioned(
                        right: -4,
                        top: -4,
                        child: DragPoint(
                          onStartMove: (offset) {
                            widget.onStartDrag();
                            startPos = Offset(
                              widthNegative
                                  ? (widget.box.box.left) * widget.zoom - offset.dx
                                  : (widget.box.box.right) * widget.zoom - offset.dx,
                              heightNegative
                                  ? (widget.box.box.bottom) * widget.zoom - offset.dy
                                  : (widget.box.box.top) * widget.zoom - offset.dy,
                            );
                          },
                          onMovePoint: (offset) {
                            widget.onChangeSize(
                              Rect.fromLTRB(
                                widthNegative
                                    ? offset.dx + startPos.dx
                                    : widget.box.box.left * widget.zoom,
                                heightNegative
                                    ? widget.box.box.top * widget.zoom
                                    : offset.dy + startPos.dy,
                                widthNegative
                                    ? widget.box.box.right * widget.zoom
                                    : offset.dx + startPos.dx,
                                heightNegative
                                    ? offset.dy + startPos.dy
                                    : widget.box.box.bottom * widget.zoom,
                              ),
                            );
                          },
                          onMoveEnd: onChangeSizeEnd,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
