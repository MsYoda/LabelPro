part of 'bounding_box_task_cubit.dart';

class BoundingBoxTaskState {
  final String imageUrl;
  final List<Label> availableLabels;
  final List<BoundingBox> boxes;
  final int creatingBoxIndex;
  final List<int> editingBoxIndexes;
  final String selectedClassId;
  final Size size;
  final bool isTaskLoading;
  final bool isEditAllEnabled;

  BoundingBoxTaskState({
    required this.imageUrl,
    required this.availableLabels,
    required this.boxes,
    required this.creatingBoxIndex,
    required this.editingBoxIndexes,
    required this.size,
    required this.selectedClassId,
    required this.isEditAllEnabled,
    required this.isTaskLoading,
  });

  BoundingBoxTaskState.initial({
    this.imageUrl = '',
    this.availableLabels = const [],
    this.creatingBoxIndex = 0,
    this.boxes = const [],
    this.size = Size.zero,
    this.editingBoxIndexes = const [],
    this.selectedClassId = '',
    this.isEditAllEnabled = false,
    this.isTaskLoading = false,
  });

  BoundingBoxTaskState copyWith({
    String? imageUrl,
    List<Label>? availableLabels,
    List<BoundingBox>? boxes,
    int? creatingBoxIndex,
    List<int>? editingBoxIndexes,
    String? selectedClassId,
    Size? size,
    bool? isTaskLoading,
    bool? isEditAllEnabled,
  }) {
    return BoundingBoxTaskState(
      imageUrl: imageUrl ?? this.imageUrl,
      selectedClassId: selectedClassId ?? this.selectedClassId,
      availableLabels: availableLabels ?? this.availableLabels,
      boxes: boxes ?? this.boxes,
      creatingBoxIndex: creatingBoxIndex ?? this.creatingBoxIndex,
      editingBoxIndexes: editingBoxIndexes ?? this.editingBoxIndexes,
      size: size ?? this.size,
      isEditAllEnabled: isEditAllEnabled ?? this.isEditAllEnabled,
      isTaskLoading: isTaskLoading ?? this.isTaskLoading,
    );
  }
}
