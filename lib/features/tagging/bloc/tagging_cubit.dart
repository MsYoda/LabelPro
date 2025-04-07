import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:label_pro_client/domain/models/dataset.dart';
import 'package:label_pro_client/domain/repository/dataset_repository.dart';
import 'package:label_pro_client/features/tagging/bloc/tagging_state.dart';

class TaggingCubit extends Cubit<TaggingState> {
  final DatasetRepository _datasetRepository;

  TaggingCubit({
    required DatasetRepository datasetRepository,
  })  : _datasetRepository = datasetRepository,
        super(
          TaggingState.initial(),
        ) {
    _init();
  }

  Future<void> _init() async {
    emit(
      state.copyWith(isLoading: true),
    );
    final Dataset dataset = await _datasetRepository.getDatasetById(1);
    emit(
      state.copyWith(
        isLoading: false,
        dataset: dataset,
      ),
    );
  }
}
