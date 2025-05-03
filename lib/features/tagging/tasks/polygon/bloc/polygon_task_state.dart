part of 'polygon_task_cubit.dart';

class PolygonTaskState {
  final String imageUrl;
  final String filename;
  final String idInFile;
  final List<Label> availableLabels;
  final List<Polygon> polygons;
  final List<int> editingPolygonsIndexes;
  final int selectedClassId;
  final Size size;
  final bool isTaskLoading;
  final bool isEditAllEnabled;
  final bool isDatasetEmpty;

  PolygonTaskState({
    required this.imageUrl,
    required this.filename,
    required this.idInFile,
    required this.availableLabels,
    required this.polygons,
    required this.editingPolygonsIndexes,
    required this.size,
    required this.selectedClassId,
    required this.isEditAllEnabled,
    required this.isTaskLoading,
    required this.isDatasetEmpty,
  });

  PolygonTaskState.initial({
    this.imageUrl = '',
    this.filename = '',
    this.idInFile = '',
    this.availableLabels = const [],
    this.polygons = const [],
    this.size = Size.zero,
    this.editingPolygonsIndexes = const [],
    this.selectedClassId = 0,
    this.isEditAllEnabled = false,
    this.isTaskLoading = false,
    this.isDatasetEmpty = false,
  });

  PolygonTaskState copyWith({
    String? imageUrl,
    String? filename,
    String? idInFile,
    List<Label>? availableLabels,
    List<Polygon>? polygons,
    List<int>? editingPolygonsIndexes,
    int? selectedClassId,
    Size? size,
    bool? isTaskLoading,
    bool? isEditAllEnabled,
    bool? isDatasetEmpty,
  }) {
    return PolygonTaskState(
      imageUrl: imageUrl ?? this.imageUrl,
      filename: filename ?? this.filename,
      idInFile: idInFile ?? this.idInFile,
      selectedClassId: selectedClassId ?? this.selectedClassId,
      availableLabels: availableLabels ?? this.availableLabels,
      polygons: polygons ?? this.polygons,
      editingPolygonsIndexes: editingPolygonsIndexes ?? this.editingPolygonsIndexes,
      size: size ?? this.size,
      isEditAllEnabled: isEditAllEnabled ?? this.isEditAllEnabled,
      isTaskLoading: isTaskLoading ?? this.isTaskLoading,
      isDatasetEmpty: isDatasetEmpty ?? this.isDatasetEmpty,
    );
  }
}
