import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:label_pro_client/features/tagging/bloc/tagging_cubit.dart';
import 'package:label_pro_client/features/tagging/tasks/word_marker/bloc/word_marker_task_cubit.dart';
import 'package:label_pro_client/features/tagging/tasks/word_marker/bloc/word_marker_task_state.dart';
import 'package:label_pro_client/features/tagging/tasks/word_marker/screen/word_marker_task_content.dart';

@RoutePage()
class WordMarkerTaskScreen extends StatelessWidget {
  const WordMarkerTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taggingState = context.read<TaggingCubit>().state;
    return BlocProvider(
      create: (_) => WordMarkerTaskCubit(
        labels: taggingState.dataset.availableLabels,
      ),
      child: BlocBuilder<WordMarkerTaskCubit, WordMarkerTaskState>(
        builder: (context, state) {
          return WordMarkerTaskContent(
            state: state,
          );
        },
      ),
    );
  }
}
