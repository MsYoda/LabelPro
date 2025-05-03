import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:label_pro_client/core/core.dart';
import 'package:label_pro_client/features/tagging/bloc/tagging_cubit.dart';
import 'package:label_pro_client/features/tagging/tasks/bounding_box/bloc/bounding_box_task_cubit.dart';
import 'package:label_pro_client/features/tagging/tasks/polygon/bloc/polygon_task_cubit.dart';

import 'polygon_task_content.dart';

@RoutePage()
class PolygonTaskScreen extends StatelessWidget {
  const PolygonTaskScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final taggingState = context.read<TaggingCubit>().state;
    return BlocProvider(
      create: (_) => PolygonTaskCubit(
        datasetRepository: appLocator(),
        labels: taggingState.dataset!.availableLabels,
      ),
      child: BlocBuilder<PolygonTaskCubit, PolygonTaskState>(
        builder: (context, state) {
          return PolygonTaskContent(
            state: state,
          );
        },
      ),
    );
  }
}
