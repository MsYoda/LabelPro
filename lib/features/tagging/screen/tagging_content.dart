import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:label_pro_client/domain/models/enums/tagging_task_type.dart';
import 'package:label_pro_client/features/tagging/bloc/tagging_state.dart';
import 'package:label_pro_client/features/tagging/tasks/bounding_box/screen/bounding_box_task_screen.dart';
import 'package:label_pro_client/features/tagging/tasks/polygon/screen/polygon_task_screen.dart';
import 'package:label_pro_client/features/tagging/tasks/word_marker/screen/word_marker_task_screen.dart';

import '../tasks/custom/screen/custom_task_screen.dart';

class TaggingContent extends StatelessWidget {
  final TaggingState state;

  const TaggingContent({
    required this.state,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (state.dataset != null) {
      return switch (state.dataset!.tasksType) {
        TaggingTaskType.boundingBox => BoundingBoxTaskScreen(),
        TaggingTaskType.wordTagging => WordMarkerTaskScreen(),
        TaggingTaskType.custom => CustomTaskScreen(),
        TaggingTaskType.polygons => PolygonTaskScreen(),
      };
    }
    return Center(
      child: Text('Для начала настройте доступ к датасету'),
    );
  }
}
