import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:label_pro_client/core/core.dart';
import 'package:label_pro_client/core/utils/image_utils.dart';
import 'package:label_pro_client/domain/exceptions/exceptions.dart';
import 'package:label_pro_client/domain/models/bounding_box.dart';
import 'package:label_pro_client/domain/models/label.dart';
import 'package:label_pro_client/domain/models/tagging_task_result.dart';
import 'package:label_pro_client/domain/models/task_types/bounding_box_solution_data.dart';
import 'package:label_pro_client/domain/repository/dataset_repository.dart';
import 'package:label_pro_client/domain/repository/settings_repository.dart';

part 'polygon_task_state.dart';

class PolygonTaskCubit extends Cubit<PolygonTaskState> {
  final DatasetRepository _datasetRepository;

  PolygonTaskCubit({
    required DatasetRepository datasetRepository,
    required List<Label> labels,
  })  : _datasetRepository = datasetRepository,
        super(
          PolygonTaskState.initial(
            availableLabels: labels,
          ),
        ) {
    _init();
  }

  Future<void> _init() async {
    print('_init');
    final labels = state.availableLabels;
    emit(
      PolygonTaskState.initial(
        availableLabels: labels,
        isTaskLoading: true,
        selectedClassId: state.selectedClassId,
      ),
    );
    try {
      final task = await _datasetRepository.getTaggingTask();

      final size = await getImageSize(
        buildFileUrl(task.data),
      );
      emit(
        state.copyWith(
          size: size,
          imageUrl: buildFileUrl(task.data),
          isTaskLoading: false,
          idInFile: task.idInFile,
          filename: task.filename,
        ),
      );
    } on DatasetIsEmpty {
      emit(
        state.copyWith(
          isDatasetEmpty: true,
          isTaskLoading: false,
        ),
      );
    }
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
        polygons: [
          ...state.polygons,
          Polygon(
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
      ),
    );
  }

  void updateBoundingBoxPosition({
    required Offset offset,
    required int index,
    required double zoom,
    required Size size,
  }) {
    if (index >= state.polygons.length) {
      return;
    }
    final oldBox = state.polygons.removeAt(index);
    final newBox = Rect.fromLTRB(
      oldBox.box.left * zoom + offset.dx,
      oldBox.box.top * zoom + offset.dy,
      oldBox.box.right * zoom + offset.dx,
      oldBox.box.bottom * zoom + offset.dy,
    );

    emit(
      state.copyWith(
        polygons: [...state.polygons]..insert(
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
    if (index >= state.polygons.length) {
      return;
    }

    final box = state.polygons[index];

    emit(
      state.copyWith(
        polygons: [...state.polygons]
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
        editingPolygonsIndexes: [index],
      ),
    );
  }

  void clearEditBoundingBox() {
    emit(
      state.copyWith(
        editingPolygonsIndexes: [],
      ),
    );
  }

  void removeBoundingBox(int index) {
    emit(
      state.copyWith(
        polygons: state.polygons..removeAt(index),
        editingPolygonsIndexes: state.editingPolygonsIndexes
            .where(
              (e) => e != index,
            )
            .toList(),
      ),
    );
  }

  void changeSelectedClassId(int newClassId) {
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

  Future<void> submitTask() async {
    print(
      BoundingBoxTaskResultData(
        boxes: state.polygons,
      ).toJson(),
    );
    final settings = await appLocator<SettingsRepository>().readSettings();
    await _datasetRepository.submitTaggingTask(
      TaggingTaskResult(
        filename: state.filename,
        idInFile: state.idInFile,
        datasetId: settings.datasetId,
        data: BoundingBoxTaskResultData(
          boxes: state.polygons,
        ).toJson(),
      ),
    );
    _init();
  }
}
