import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:label_pro_client/domain/models/bounding_box.dart';
import 'package:label_pro_client/domain/models/label.dart';
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
        print(c);
        final zoomX = c.maxWidth / widget.state.size.width;
        final zoomY = c.maxHeight / widget.state.size.height;
        print(zoomX);
        print(zoomY);
        final zoom = min(zoomX, zoomY);
        print(zoom);
        print('width');
        print(widget.state.size.width * zoom);
        print('height');
        print(widget.state.size.height * zoom);
        return Stack(
          fit: StackFit.loose,
          children: [
            GestureDetector(
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
                    _startPoint!.dx + 2,
                    _startPoint!.dy + 2,
                  ),
                  BoxConstraints(
                    maxHeight: widget.state.size.height * zoom,
                    maxWidth: widget.state.size.width * zoom,
                  ),
                );

                cubit.createBoundingBox(
                  BoundingBox(
                    box: rect,
                    label: Label(
                      id: '1',
                      name: 'Car',
                    ),
                  ),
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
                    key: ValueKey(
                      'https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg',
                    ),
                    'https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg',
                    fit: BoxFit.cover,
                    width: widget.state.size.width * zoom,
                    height: widget.state.size.height * zoom,
                  ),
                ),
              ),
            ),
            for (var i = 0; i < widget.state.boxes.length; i++)
              Positioned(
                top: widget.state.boxes[i].box.withCorrectCorners.top * zoom,
                left: widget.state.boxes[i].box.withCorrectCorners.left * zoom,
                child: BoundingBoxContainer(
                  box: widget.state.boxes[i],
                  zoom: zoom,
                  isEditing: widget.state.editingBoxIndex == i,
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
              ),
            IconButton(
              onPressed: () {
                cubit.editBoundingBox(
                  widget.state.boxes.length - 1,
                );
              },
              icon: Icon(
                Icons.security,
                color: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}
