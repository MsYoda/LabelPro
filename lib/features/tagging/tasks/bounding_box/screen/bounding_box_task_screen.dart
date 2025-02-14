import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:label_pro_client/features/tagging/tasks/bounding_box/bloc/bounding_box_task_cubit.dart';

import 'bounding_box_task_content.dart';

@RoutePage()
class BoundingBoxTaskScreen extends StatelessWidget {
  const BoundingBoxTaskScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BoundingBoxTaskCubit(),
      child: BlocBuilder<BoundingBoxTaskCubit, BoundingBoxTaskState>(
        builder: (context, state) {
          return Scaffold(
            body: BoundingBoxTaskContent(
              state: state,
            ),
          );
        },
      ),
    );
  }
}
