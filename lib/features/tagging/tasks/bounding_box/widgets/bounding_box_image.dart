import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:label_pro_client/core_ui/theme/app_colors.dart';
import 'package:label_pro_client/features/tagging/tasks/bounding_box/bloc/bounding_box_task_cubit.dart';
import 'package:label_pro_client/features/tagging/tasks/bounding_box/utils/bounding_box_utils.dart';
import 'package:label_pro_client/features/tagging/tasks/bounding_box/utils/rect_ext.dart';
import 'package:label_pro_client/features/tagging/tasks/bounding_box/widgets/bounding_box_container.dart';

class BoundingBoxImage extends StatefulWidget {
  final BoundingBoxTaskState state;

  const BoundingBoxImage({
    required this.state,
    super.key,
  });

  @override
  State<BoundingBoxImage> createState() => _BoundingBoxImageState();
}

class _BoundingBoxImageState extends State<BoundingBoxImage> {
  Offset? _startPoint;
  Offset? _endPoint;
  bool isDragActive = false;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BoundingBoxTaskCubit>();
    return LayoutBuilder(
      builder: (context, c) {
        final zoomX = c.maxWidth / widget.state.size.width;
        final zoomY = c.maxHeight / widget.state.size.height;
        final zoom = min(zoomX, zoomY);

        return Stack(
          fit: StackFit.loose,
          children: [
            IgnorePointer(
              ignoring: !widget.state.availableLabels.map((e) => e.id).contains(
                        widget.state.selectedClassId,
                      ) ||
                  widget.state.availableLabels.isEmpty,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                supportedDevices: {
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.touch,
                },
                onPanStart: (details) {
                  _startPoint = details.localPosition;
                  final rect = getClampedRect(
                    _startPoint!,
                    Offset(
                      _startPoint!.dx + 20,
                      _startPoint!.dy + 20,
                    ),
                    BoxConstraints(
                      maxHeight: widget.state.size.height * zoom,
                      maxWidth: widget.state.size.width * zoom,
                    ),
                  );

                  cubit.createBoundingBox(
                    rect,
                    Size(
                      widget.state.size.width * zoom,
                      widget.state.size.height * zoom,
                    ),
                  );
                },
                onPanUpdate: (details) {
                  _endPoint = details.localPosition;

                  final rect = getClampedRect(
                    _startPoint!,
                    _endPoint!,
                    BoxConstraints(
                      maxHeight: widget.state.size.height * zoom,
                      maxWidth: widget.state.size.width * zoom,
                    ),
                  );

                  cubit.updateBoundingBoxSize(
                    newPosition: rect,
                    index: widget.state.creatingBoxIndex,
                    size: Size(
                      widget.state.size.width * zoom,
                      widget.state.size.height * zoom,
                    ),
                  );
                },
                onPanEnd: (_) {
                  _startPoint = null;
                  _endPoint = null;
                },
                child: MouseRegion(
                  cursor: isDragActive ? SystemMouseCursors.grabbing : MouseCursor.defer,
                  child: SizedBox(
                    child: Image.network(
                      widget.state.imageUrl,
                      fit: BoxFit.cover,
                      width: widget.state.size.width * zoom,
                      height: widget.state.size.height * zoom,
                    ),
                  ),
                ),
              ),
            ),
            for (var i = 0; i < widget.state.boxes.length; i++)
              Builder(builder: (context) {
                Color color = AppColors.pink;
                widget.state.availableLabels.asMap().forEach(
                  (key, value) {
                    if (value.id == widget.state.boxes[i].label.id) {
                      color = AppColors.accentColorFromIndex(key);
                    }
                  },
                );
                return Positioned(
                  top: widget.state.boxes[i].box.withCorrectCorners.top * zoom,
                  left: widget.state.boxes[i].box.withCorrectCorners.left * zoom,
                  child: BoundingBoxContainer(
                    box: widget.state.boxes[i],
                    color: color,
                    zoom: zoom,
                    isEditing:
                        widget.state.editingBoxIndexes.contains(i) || widget.state.isEditAllEnabled,
                    isDragged: isDragActive,
                    onStartDrag: () {
                      setState(() {
                        isDragActive = true;
                      });
                    },
                    onEndDrag: () {
                      setState(() {
                        isDragActive = false;
                      });
                    },
                    onChangeSize: (newRect) {
                      cubit.updateBoundingBoxSize(
                        newPosition: newRect.clamped(
                          BoxConstraints(
                            maxWidth: widget.state.size.width * zoom,
                            maxHeight: widget.state.size.height * zoom,
                          ),
                        ),
                        index: i,
                        size: Size(
                          widget.state.size.width * zoom,
                          widget.state.size.height * zoom,
                        ),
                      );
                    },
                    onMove: (dragOffset) {
                      cubit.updateBoundingBoxPosition(
                        offset: dragOffset,
                        index: i,
                        zoom: zoom,
                        size: Size(
                          widget.state.size.width * zoom,
                          widget.state.size.height * zoom,
                        ),
                      );
                    },
                  ),
                );
              }),
          ],
        );
      },
    );
  }
}
