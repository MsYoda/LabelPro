import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:label_pro_client/core/core.dart';
import 'package:label_pro_client/features/tagging/tasks/custom/bloc/custom_task_cubit.dart';
import 'package:label_pro_client/features/tagging/tasks/custom/bloc/custom_task_state.dart';
import 'package:label_pro_client/features/tagging/tasks/custom/screen/custom_task_content.dart';

import '../../../bloc/tagging_cubit.dart';

@RoutePage()
class CustomTaskScreen extends StatelessWidget {
  const CustomTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taggingState = context.read<TaggingCubit>().state;
    return BlocProvider(
      create: (_) => CustomTaskCubit(
        datasetRepository: appLocator(),
        labels: taggingState.dataset!.availableLabels,
      ),
      child: BlocBuilder<CustomTaskCubit, CustomTaskState>(
          builder: (context, state) {
        return CustomTaskContent(
          state: state,
        );
      }),
    );
  }
}
