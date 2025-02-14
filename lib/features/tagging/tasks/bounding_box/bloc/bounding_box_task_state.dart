part of 'bounding_box_task_cubit.dart';

class BoundingBoxTaskState {
  final String imageUrl;
  final List<BoundingBox> boxes;
  final int creatingBoxIndex;
  final int? editingBoxIndex;
  final Size size;

  BoundingBoxTaskState({
    required this.imageUrl,
    required this.boxes,
    required this.creatingBoxIndex,
    required this.editingBoxIndex,
    required this.size,
  });

  BoundingBoxTaskState.initial({
    this.imageUrl = '',
    this.creatingBoxIndex = 0,
    this.boxes = const [],
    this.size = Size.zero,
    this.editingBoxIndex,
  });

  BoundingBoxTaskState copyWith({
    String? imageUrl,
    List<BoundingBox>? boxes,
    int? creatingBoxIndex,
    int Function()? editingBoxIndex,
    Size? size,
  }) {
    return BoundingBoxTaskState(
      imageUrl: imageUrl ?? this.imageUrl,
      boxes: boxes ?? this.boxes,
      creatingBoxIndex: creatingBoxIndex ?? this.creatingBoxIndex,
      editingBoxIndex: editingBoxIndex?.call() ?? this.editingBoxIndex,
      size: size ?? this.size,
    );
  }
}
