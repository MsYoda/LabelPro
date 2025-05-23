import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:label_pro_client/core/core.dart';
import 'package:label_pro_client/core/utils/image_utils.dart';
import 'package:label_pro_client/domain/exceptions/exceptions.dart';
import 'package:label_pro_client/domain/models/label.dart';
import 'package:label_pro_client/domain/models/polygon.dart';
import 'package:label_pro_client/domain/models/tagging_task_result.dart';
import 'package:label_pro_client/domain/models/task_types/polygon_solution_data.dart';
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
      final appSettings = await appLocator<SettingsRepository>().readSettings();
      final url = buildFileUrl(
        host: appSettings.serverAddress,
        port: appSettings.servicePort,
        filePath: task.data,
      );

      final size = await getImageSize(url);
      emit(
        state.copyWith(
          size: size,
          imageUrl: url,
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

  void createPolygon(
    List<Offset> points,
    Size size,
  ) {
    emit(
      state.copyWith(
        polygons: state.polygons
          ..add(
            Polygon(
              points: points,
              label: state.availableLabels[state.selectedClassId],
            ),
          ),
      ),
    );
  }

  void updatePolygons(List<Polygon> polygons) {
    emit(state.copyWith(polygons: polygons));
  }

  void updatePolyPointPosition({
    required Offset offset,
    required int index,
    required int pointIndex,
    required Size size,
  }) {
    final updatedPolygons = [...state.polygons];
    updatedPolygons[index].points[pointIndex] = offset;

    emit(
      state.copyWith(
        polygons: updatedPolygons,
      ),
    );
  }

  void addPointToPolygon({
    required Offset point,
    required int index,
    required int polyIndex,
  }) {
    final updatedPolygons = [...state.polygons];
    final points = updatedPolygons[index].points;
    points.insert(index, point);
    final oldPoly = updatedPolygons.removeAt(polyIndex);
    updatedPolygons.insert(
      polyIndex,
      Polygon(points: points, label: oldPoly.label),
    );

    emit(
      state.copyWith(polygons: updatedPolygons),
    );
  }

  void editPolygon(int index) {
    emit(
      state.copyWith(
        editingPolygonsIndexes: [index],
      ),
    );
  }

  void clearEditPolygon() {
    emit(
      state.copyWith(
        editingPolygonsIndexes: [],
      ),
    );
  }

  void removePolygon(int index) {
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
    print(state.polygons.first.points);
    final settings = await appLocator<SettingsRepository>().readSettings();
    await _datasetRepository.submitTaggingTask(
      TaggingTaskResult(
        filename: state.filename,
        idInFile: state.idInFile,
        datasetId: settings.datasetId,
        data: PolygonSolutionData(polygons: state.polygons).toJson(),
      ),
    );
    _init();
  }
}
