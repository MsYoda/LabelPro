import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:label_pro_client/core/utils/image_utils.dart';
import 'package:label_pro_client/domain/models/bounding_box.dart';
import 'package:label_pro_client/domain/models/label.dart';

part 'bounding_box_task_state.dart';

class BoundingBoxTaskCubit extends Cubit<BoundingBoxTaskState> {
  BoundingBoxTaskCubit({
    required List<Label> labels,
  }) : super(
          BoundingBoxTaskState.initial(
            availableLabels: labels,
          ),
        ) {
    _init();
  }

  Future<void> _init() async {
    final size = await getImageSize(
      'https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg',
    );
    emit(
      state.copyWith(
        size: size,
      ),
    );
  }

  Rect _resizeToImageSize({
    required Rect rect,
    required Size originalSize,
  }) {
    final Rect normalizedRect = Rect.fromLTRB(
      rect.left / originalSize.width,
      rect.top / originalSize.height,
      rect.right / originalSize.width,
      rect.bottom / originalSize.height,
    );

    return Rect.fromLTRB(
      normalizedRect.left * state.size.width,
      normalizedRect.top * state.size.height,
      normalizedRect.right * state.size.width,
      normalizedRect.bottom * state.size.height,
    );
  }

  void createBoundingBox(
    Rect rect,
    Size size,
  ) {
    emit(
      state.copyWith(
        boxes: [
          ...state.boxes,
          BoundingBox(
            box: _resizeToImageSize(
              rect: rect,
              originalSize: size,
            ),
            label: Label(
              id: state.selectedClassId,
              name: state.availableLabels
                      .where((e) => e.id == state.selectedClassId)
                      .firstOrNull
                      ?.name ??
                  '',
            ),
          )
        ],
        creatingBoxIndex: state.boxes.length,
      ),
    );
  }

  void updateBoundingBoxPosition({
    required Offset offset,
    required int index,
    required double zoom,
    required Size size,
  }) {
    if (index >= state.boxes.length) {
      return;
    }
    final oldBox = state.boxes.removeAt(index);
    final newBox = Rect.fromLTRB(
      oldBox.box.left * zoom + offset.dx,
      oldBox.box.top * zoom + offset.dy,
      oldBox.box.right * zoom + offset.dx,
      oldBox.box.bottom * zoom + offset.dy,
    );

    emit(
      state.copyWith(
        boxes: [...state.boxes]..insert(
            index,
            oldBox.copyWith(
              box: _resizeToImageSize(
                rect: newBox,
                originalSize: size,
              ),
            ),
          ),
      ),
    );
  }

  void updateBoundingBoxSize({
    required Rect newPosition,
    required int index,
    required Size size,
  }) {
    if (index >= state.boxes.length) {
      return;
    }

    final box = state.boxes[index];

    emit(
      state.copyWith(
        boxes: [...state.boxes]
          ..removeAt(index)
          ..insert(
            index,
            box.copyWith(
              box: _resizeToImageSize(
                rect: newPosition,
                originalSize: size,
              ),
            ),
          ),
      ),
    );
  }

  void editBoundingBox(int index) {
    emit(
      state.copyWith(
        editingBoxIndexes: [index],
      ),
    );
  }

  void clearEditBoundingBox() {
    emit(
      state.copyWith(
        editingBoxIndexes: [],
      ),
    );
  }

  void removeBoundingBox(int index) {
    emit(
      state.copyWith(
        boxes: state.boxes..removeAt(index),
        editingBoxIndexes: state.editingBoxIndexes
            .where(
              (e) => e != index,
            )
            .toList(),
      ),
    );
  }

  void changeSelectedClassId(String newClassId) {
    emit(
      state.copyWith(selectedClassId: newClassId),
    );
  }

  void updateEditAll(bool value) {
    emit(
      state.copyWith(
        isEditAllEnabled: value,
      ),
    );
  }
}
