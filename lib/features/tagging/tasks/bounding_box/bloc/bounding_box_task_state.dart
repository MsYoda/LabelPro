part of 'bounding_box_task_cubit.dart';

class BoundingBoxTaskState {
  final String imageUrl;
  final String filename;
  final String idInFile;
  final List<Label> availableLabels;
  final List<BoundingBox> boxes;
  final int creatingBoxIndex;
  final List<int> editingBoxIndexes;
  final int selectedClassId;
  final Size size;
  final bool isTaskLoading;
  final bool isEditAllEnabled;
  final bool isDatasetEmpty;

  BoundingBoxTaskState({
    required this.imageUrl,
    required this.filename,
    required this.idInFile,
    required this.availableLabels,
    required this.boxes,
    required this.creatingBoxIndex,
    required this.editingBoxIndexes,
    required this.size,
    required this.selectedClassId,
    required this.isEditAllEnabled,
    required this.isTaskLoading,
    required this.isDatasetEmpty,
  });

  BoundingBoxTaskState.initial({
    this.imageUrl = '',
    this.filename = '',
    this.idInFile = '',
    this.availableLabels = const [],
    this.creatingBoxIndex = 0,
    this.boxes = const [],
    this.size = Size.zero,
    this.editingBoxIndexes = const [],
    this.selectedClassId = 0,
    this.isEditAllEnabled = false,
    this.isTaskLoading = false,
    this.isDatasetEmpty = false,
  });

  BoundingBoxTaskState copyWith({
    String? imageUrl,
    String? filename,
    String? idInFile,
    List<Label>? availableLabels,
    List<BoundingBox>? boxes,
    int? creatingBoxIndex,
    List<int>? editingBoxIndexes,
    int? selectedClassId,
    Size? size,
    bool? isTaskLoading,
    bool? isEditAllEnabled,
    bool? isDatasetEmpty,
  }) {
    return BoundingBoxTaskState(
      imageUrl: imageUrl ?? this.imageUrl,
      filename: filename ?? this.filename,
      idInFile: idInFile ?? this.idInFile,
      selectedClassId: selectedClassId ?? this.selectedClassId,
      availableLabels: availableLabels ?? this.availableLabels,
      boxes: boxes ?? this.boxes,
      creatingBoxIndex: creatingBoxIndex ?? this.creatingBoxIndex,
      editingBoxIndexes: editingBoxIndexes ?? this.editingBoxIndexes,
      size: size ?? this.size,
      isEditAllEnabled: isEditAllEnabled ?? this.isEditAllEnabled,
      isTaskLoading: isTaskLoading ?? this.isTaskLoading,
      isDatasetEmpty: isDatasetEmpty ?? this.isDatasetEmpty,
    );
  }
}
