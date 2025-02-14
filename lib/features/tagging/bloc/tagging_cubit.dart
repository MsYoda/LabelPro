import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:label_pro_client/domain/models/dataset.dart';
import 'package:label_pro_client/domain/models/enums/tagging_task_type.dart';
import 'package:label_pro_client/domain/models/label.dart';
import 'package:label_pro_client/features/tagging/bloc/tagging_state.dart';

class TaggingCubit extends Cubit<TaggingState> {
  TaggingCubit()
      : super(
          TaggingState.initial(),
        ) {
    _init();
  }

  void _init() {
    emit(
      state.copyWith(
        dataset: Dataset(
          id: 'id',
          availableLabels: [
            Label(id: 'id1', name: 'Cat'),
            Label(id: 'id2', name: 'Dog'),
            Label(id: 'id3', name: 'Person'),
          ],
          tasksType: TaggingTaskType.boundingBox,
        ),
      ),
    );
  }
}
