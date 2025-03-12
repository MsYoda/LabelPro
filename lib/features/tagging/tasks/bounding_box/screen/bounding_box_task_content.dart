import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:label_pro_client/core_ui/theme/app_colors.dart';
import 'package:label_pro_client/domain/models/label.dart';

import '../bloc/bounding_box_task_cubit.dart';
import '../widgets/bounding_box_image.dart';

class BoundingBoxTaskContent extends StatelessWidget {
  final BoundingBoxTaskState state;

  const BoundingBoxTaskContent({
    required this.state,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BoundingBoxTaskCubit>();
    return GestureDetector(
      onTap: () {
        cubit.clearEditBoundingBox();
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Center(
                      child: BoundingBoxImage(state: state),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      cubit.clearEditBoundingBox();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                      child: LayoutBuilder(builder: (context, constraints) {
                        return SizedBox(
                          height: constraints.maxHeight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: AvailableLabelsList(
                                  state: state,
                                  onPressed: (index) => cubit.changeSelectedClassId(
                                    state.availableLabels[index].id,
                                  ),
                                ),
                              ),
                              SizedBox(height: 25),
                              Expanded(
                                flex: 2,
                                child: TaggedLabelsList(
                                  state: state,
                                  onClearSelection: cubit.clearEditBoundingBox,
                                  onEditPressed: () => cubit.updateEditAll(!state.isEditAllEnabled),
                                  onLabelPressed: (index) => cubit.editBoundingBox(index),
                                  onLabelRemoved: (index) => cubit.removeBoundingBox(index),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AvailableLabelsList extends StatelessWidget {
  const AvailableLabelsList({
    required this.state,
    required this.onPressed,
    super.key,
  });

  final BoundingBoxTaskState state;
  final Function(int) onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black.withValues(alpha: 0.17),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Available labels',
            ),
          ),
          SizedBox(height: 4),
          Expanded(
            child: ListView.builder(
              itemCount: state.availableLabels.length,
              itemBuilder: (context, index) {
                return LabelListTile(
                  label: state.availableLabels[index],
                  isSelected: state.availableLabels[index].id == state.selectedClassId,
                  color: AppColors.accentColorFromIndex(index),
                  onPressed: () => onPressed(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TaggedLabelsList extends StatelessWidget {
  const TaggedLabelsList({
    required this.state,
    required this.onLabelPressed,
    required this.onLabelRemoved,
    required this.onEditPressed,
    required this.onClearSelection,
    super.key,
  });

  final BoundingBoxTaskState state;
  final Function(int) onLabelPressed;
  final Function(int) onLabelRemoved;
  final Function() onEditPressed;
  final VoidCallback onClearSelection;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: 300,
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black.withValues(alpha: 0.17),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Text(
                  'Labels list',
                ),
                Spacer(),
                Material(
                  color: Colors.transparent,
                  shape: CircleBorder(),
                  child: InkWell(
                    onTap: onClearSelection,
                    customBorder: CircleBorder(),
                    child: Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.clear_all,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                Material(
                  shape: CircleBorder(),
                  color: state.isEditAllEnabled ? colors.primary : colors.surface,
                  child: InkWell(
                    onTap: onEditPressed,
                    customBorder: CircleBorder(),
                    child: Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.select_all,
                        size: 18,
                        color: state.isEditAllEnabled ? colors.onPrimary : colors.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
          Expanded(
            child: ListView.builder(
              itemCount: state.boxes.length,
              itemBuilder: (BuildContext context, int index) {
                Color color = AppColors.pink;
                state.availableLabels.asMap().forEach(
                  (key, value) {
                    if (value.id == state.boxes[index].label.id) {
                      color = AppColors.accentColorFromIndex(key);
                    }
                  },
                );

                return LabelListTile(
                  label: state.boxes[index].label,
                  color: color,
                  isSelected: state.editingBoxIndexes.contains(index),
                  onRemovePressed: () => onLabelRemoved(index),
                  onPressed: () => onLabelPressed(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LabelListTile extends StatelessWidget {
  final Label label;
  final bool isSelected;
  final VoidCallback? onRemovePressed;
  final VoidCallback onPressed;
  final Color color;

  const LabelListTile({
    required this.label,
    required this.onPressed,
    required this.isSelected,
    required this.color,
    this.onRemovePressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: isSelected ? colors.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  label.name,
                  maxLines: 2,
                  style: TextStyle(
                    color: isSelected ? colors.onPrimary : colors.onSurface,
                  ),
                ),
              ),
              Opacity(
                opacity: onRemovePressed == null ? 0 : 1,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: CircleBorder(),
                    onTap: onRemovePressed,
                    child: Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: isSelected ? colors.onPrimary : colors.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
